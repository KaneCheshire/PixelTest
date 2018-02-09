//
//  PixelTestCase.swift
//  PixelTest
//
//  Created by Kane Cheshire on 13/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest

// TODO: CONTRIBUTING
// TODO: CHANGELOG

/// Subclass `PixelTestCase` and `import PixelTest`
open class PixelTestCase: XCTestCase {
    
    // MARK: - Enums -
    // MARK: Public
    
    /// Represents the scale of the resulting snapshot image.
    /// I.e. whether it's @1x, @2x, @3x etc.
    ///
    /// - native: Uses the device's native scale. (@2x on an iPhone SE, @3x on an iPhone 8)
    /// - explicit: Forces an explicit scale, regardless of device.
    public enum Scale {
        case native
        case explicit(CGFloat)
        
        var explicitOrScreenNativeValue: CGFloat {
            switch self {
            case .native: return UIScreen.main.scale
            case .explicit(let explicit): return explicit
            }
        }
        
        var explicitOrCoreGraphicsValue: CGFloat {
            switch self {
            case .native: return 0
            case .explicit(let explicit): return explicit
            }
        }
    }
    
    /// Represents a mode that the test/tests are running in.
    /// Typically you would change this in `setUp()`.
    ///
    /// - record: The tests are running in record mode. While this mode is set, any tests that run record a snapshot, overwriting any existing snapshots for that test.
    /// - test: The tests are running in test mode. While this mode is set, any tests that run will be verified against recorded snapshots.
    public enum Mode {
        case record
        case test
    }
    
    /// Represents an option for verifying a view.
    ///
    /// - dynamicWidth: The view should have a dynamic width, but fixed height.
    /// - dynamicHeight: The view should have a dynamic height, but fixed width.
    /// - dynamicWidthHeight: The view should have a dynamic width and height.
    /// - fixed: The view should have a fixed width and height.
    public enum Option {
        case dynamicWidth(fixedHeight: CGFloat)
        case dynamicHeight(fixedWidth: CGFloat)
        case dynamicWidthHeight
        case fixed(width: CGFloat, height: CGFloat)
    }
    
    /// Represents an error that could occur specific to `PixelTestCase`.
    ///
    /// - viewHasNoWidth: The view provided has no width so cannot be verified.
    /// - viewHasNoHeight: The view provided has no height so canot be verified.
    /// - unableToCreateImage: The test case was unable to create an image for recording or testing.
    /// - noKeyWindow: The tests were unable to find a key window for the shared application, which is needed for snapshotting.
    /// - unableToCreateFileURL: The tests were unable to create a file URL required for testing.
    public enum Error: Swift.Error {
        case viewHasNoWidth
        case viewHasNoHeight
        case unableToCreateImage
        case noKeyWindow
        case unableToCreateFileURL
    }
    
    // MARK: Private
    
    private enum ImageType: String {
        case reference = "Reference"
        case diff = "Diff"
        case failure = "Failure"
    }
    
    // MARK: - Properties -
    // MARK: Public
    
    public var mode: Mode = .test
    
    // MARK: - Functions -
    // MARK: Public
    
    /// Verifies a view.
    /// If this is called while in record mode, a new snapshot are recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - option: The options to verify the view with.
    ///   - scale: The scale to record/test the snapshot with.
    public func verify(_ view: UIView,
                       option: Option,
                       scale: Scale = .explicit(1),
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) throws {
        layOut(view, with: option)
        guard view.bounds.width != 0 else { throw Error.viewHasNoWidth }
        guard view.bounds.height != 0 else { throw Error.viewHasNoHeight }
        view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width.rounded(.up), height: view.bounds.height.rounded(.up)) // Horrible hacky thing to make sure images are recorded at the same size as the bounds
        switch mode {
        case .record: try record(view, scale: scale, file: file, function: function, line: line)
        case .test: try test(view, scale: scale, file: file, function: function, line: line)
        }
    }
    
    // MARK: Private
    
    private func layOut(_ view: UIView,
                        with option: Option) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch option {
        case .dynamicHeight(fixedWidth: let width):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        case .dynamicWidth(fixedHeight: let height):
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fixed(width: let width, height: let height):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dynamicWidthHeight: break
        }
        embed(view)
    }
    
    private func embed(_ view: UIView) {
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            ])
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded() // TODO: I don't think this is needed
    }
    
    private func record(_ view: UIView,
                        scale: Scale, // TODO: Scale stuff isn't working properly across different scale simulators yet
                        file: StaticString,
                        function: StaticString,
                        line: UInt) throws {
        guard let url = try fileURL(forFunction: function, scale: scale, imageType: .reference) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = UIImagePNGRepresentation(image)
        try data?.write(to: url, options: .atomic)
        XCTFail("Snapshot recorded, disable record mode and re-run tests to verify.", file: file, line: line)
    }
    
    private func test(_ view: UIView,
                      scale: Scale,
                      file: StaticString,
                      function: StaticString,
                      line: UInt) throws {
        guard let url = try fileURL(forFunction: function, scale: scale, imageType: .reference) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = try Data(contentsOf: url, options: .uncached)
        let recordedImage = UIImage(data: data, scale: scale.explicitOrScreenNativeValue)!
        if !image.equalTo(recordedImage) {
            try storeDiffAndFailureImages(from: image, recordedImage: recordedImage, function: function, scale: scale)
            XCTFail("Snapshots do not match", file: file, line: line) // TODO: Clearer messaging
        } else {
            try removeDiffAndFailureImages(function: function, scale: scale)
        }
    }
    
    private func storeDiffAndFailureImages(from originalImage: UIImage,
                                           recordedImage: UIImage,
                                           function: StaticString,
                                           scale: Scale) throws {
        if let diffImage = originalImage.diff(with: recordedImage), let url = try fileURL(forFunction: function, scale: scale, imageType: .diff) {
            let data = UIImagePNGRepresentation(diffImage)
            try data?.write(to: url, options: .atomic) // TODO: This will fail the test if it fails, intended?
        }
        if let url = try fileURL(forFunction: function, scale: scale, imageType: .failure) {
            let data = UIImagePNGRepresentation(originalImage)
            try data?.write(to: url, options: .atomic)
        }
    }
    
    private func removeDiffAndFailureImages(function: StaticString,
                                            scale: Scale) throws {
        if let url = try fileURL(forFunction: function, scale: scale, imageType: .diff) {
            try? FileManager.default.removeItem(at: url)
        }
        if let url = try fileURL(forFunction: function, scale: scale, imageType: .failure) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    private func fileURL(forFunction function: StaticString,
                         scale: Scale,
                         imageType: ImageType) throws -> URL? {
        let baseDirectory = baseDirectoryPath(with: imageType)
        try createBaseDirectoryIfNecessary(baseDirectory)
        return fullFileURL(withBaseDirectoryPath: baseDirectory, function: function, scale: scale)
    }
    
    private func baseDirectoryPath(with imageType: ImageType) -> String {
        guard let baseDirectory = ProcessInfo.processInfo.environment["PIXELTEST_DIR"] else { fatalError("Please set `PIXELTEST_DIR` as an environment variable") }
        let typeComponents = String(reflecting: type(of: self)).components(separatedBy: ".")
        let moduleName = typeComponents[safe: 0] ?? "Unknown"
        let className = typeComponents[safe: 1] ?? "Unknown"
        return "\(baseDirectory)/\(moduleName)/\(imageType.rawValue)/\(className)"
    }
    
    private func createBaseDirectoryIfNecessary(_ baseDirectoryPath: String) throws {
        guard !FileManager.default.fileExists(atPath: baseDirectoryPath) else { return }
        try FileManager.default.createDirectory(atPath: baseDirectoryPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func fullFileURL(withBaseDirectoryPath baseDirectoryPath: String,
                             function: StaticString,
                             scale: Scale) -> URL? {
        let functionWithParenthesisRemoved = "\(function)".trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let path = "\(baseDirectoryPath)/\(functionWithParenthesisRemoved)@\(scale.explicitOrScreenNativeValue)x.png"
        return URL(fileURLWithPath: path)
    }
    
}

extension UIView { // TODO: Move
    
    func image(withScale scale: PixelTestCase.Scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale.explicitOrCoreGraphicsValue)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIImage { // TODO: Move
    
    func equalTo(_ image: UIImage) -> Bool {
        guard size == image.size else { return false }
        return UIImagePNGRepresentation(self) == UIImagePNGRepresentation(image)
    }
    
    func diff(with image: UIImage) -> UIImage? { // TODO: split this up
        let maxWidth = max(size.width, image.size.width)
        let maxHeight = max(size.height, image.size.height)
        let diffSize = CGSize(width: maxWidth, height: maxHeight)
        UIGraphicsBeginImageContextWithOptions(diffSize, true, scale)
        let context = UIGraphicsGetCurrentContext()
        draw(in: CGRect(origin: .zero, size: size))
        context?.setAlpha(0.5)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        context?.setBlendMode(.difference)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(origin: .zero, size: diffSize))
        context?.endTransparencyLayer()
        let diffImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return diffImage
    }

}

extension Array {
    
    subscript(safe index: Index) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}
