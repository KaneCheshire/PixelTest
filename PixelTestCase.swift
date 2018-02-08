//
//  PixelTestCase.swift
//  PixelTest
//
//  Created by Kane Cheshire on 13/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest

// TODO: README
// TODO: CONTRIBUTING
// TODO: CHANGELOG

/// Subclass `PixelTestCase` and `import PixelTest`
open class PixelTestCase: XCTestCase {
    
    // MARK: - Enums -
    // MARK: Public
    
    /// <#Description#>
    ///
    /// - native: <#native description#>
    /// - explicit: <#explicit description#>
    public enum Scale {
        case native
        case explicit(CGFloat)
    }
    
    /// <#Description#>
    ///
    /// - record: <#record description#>
    /// - test: <#test description#>
    public enum Mode {
        case record
        case test
    }
    
    /// <#Description#>
    ///
    /// - dynamicWidth: <#dynamicWidth description#>
    /// - dynamicHeight: <#dynamicHeight description#>
    /// - dynamicHeightWidth: <#dynamicHeightWidth description#>
    /// - fixed: <#fixed description#>
    public enum Options {
        case dynamicWidth(fixedHeight: CGFloat)
        case dynamicHeight(fixedWidth: CGFloat)
        case dynamicHeightWidth
        case fixed(width: CGFloat, height: CGFloat)
    }
    
    /// <#Description#>
    ///
    /// - viewHasNoWidth: <#viewHasNoWidth description#>
    /// - viewHasNoHeight: <#viewHasNoHeight description#>
    /// - unableToCreateImage: <#unableToCreateImage description#>
    /// - noKeyWindow: <#noKeyWindow description#>
    /// - unableToCreateFileURL: <#unableToCreateFileURL description#>
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
    
    public func verify(_ view: UIView,
                       options: Options,
                       scale: Scale = .explicit(1),
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) throws {
        guard let window = UIApplication.shared.keyWindow else { throw Error.noKeyWindow }
        window.addSubview(view)
        layOut(view, with: options)
        guard view.bounds.width != 0 else { throw Error.viewHasNoWidth }
        guard view.bounds.height != 0 else { throw Error.viewHasNoHeight }
        view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width.rounded(.up), height: view.bounds.width.rounded(.up))
        switch mode {
        case .record: try record(view, window: window, scale: scale, file: file, function: function)
        case .test: try test(view, window: window, scale: scale, file: file, function: function)
        }
    }
    
    // MARK: Private
    
    private func layOut(_ view: UIView,
                        with options: Options) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch options {
        case .dynamicHeight(fixedWidth: let width):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        case .dynamicWidth(fixedHeight: let height):
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fixed(width: let width, height: let height):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dynamicHeightWidth: break
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
        view.layoutIfNeeded()
    }
    
    private func record(_ view: UIView,
                        window: UIWindow,
                        scale: Scale,
                        file: StaticString,
                        function: StaticString,
                        line: UInt = #line) throws {
        guard let url = try fileURL(forFunction: function, scale: scale, imageType: .reference) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = UIImagePNGRepresentation(image)
        try data?.write(to: url, options: .atomic)
        XCTFail("Snapshot recorded, disable record mode and re-run tests to verify.", file: file, line: line)
    }
    
    private func test(_ view: UIView,
                      window: UIWindow,
                      scale: Scale,
                      file: StaticString,
                      function: StaticString,
                      line: UInt = #line) throws {
        guard let url = try fileURL(forFunction: function, scale: scale, imageType: .reference) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = try Data(contentsOf: url, options: .uncached)
        let imageScale: CGFloat
        switch scale {
        case .native: imageScale = UIScreen.main.scale
        case .explicit(let explicitScale): imageScale = explicitScale
        }
        let recordedImage = UIImage(data: data, scale: imageScale)!
        if !image.equalTo(recordedImage) {
            if let diffImage = image.diff(with: recordedImage), let url = try fileURL(forFunction: function, scale: scale, imageType: .diff) { // TODO: Get rid of nesting
                let data = UIImagePNGRepresentation(diffImage)
                try data?.write(to: url, options: .atomic)
            }
            if let url = try fileURL(forFunction: function, scale: scale, imageType: .failure) {
                let data = UIImagePNGRepresentation(image)
                try data?.write(to: url, options: .atomic)
            }
            XCTFail("Snapshots do not match", file: file, line: line) // TODO: Clearer messaging
        } else {
            if let url = try fileURL(forFunction: function, scale: scale, imageType: .diff) {
                try? FileManager.default.removeItem(at: url)
            }
            if let url = try fileURL(forFunction: function, scale: scale, imageType: .failure) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
    
    private func fileURL(forFunction function: StaticString,
                         scale: Scale,
                         imageType: ImageType) throws -> URL? {
        guard let directory = ProcessInfo.processInfo.environment["PIXELTEST_DIR"] else { fatalError("Please set `PIXEL_TESTS_DIR` as an environment variable") }
        let directoryWithImageType = "\(directory)/\(imageType.rawValue)"
        if !FileManager.default.fileExists(atPath: directoryWithImageType) {
            try FileManager.default.createDirectory(atPath: directoryWithImageType, withIntermediateDirectories: true, attributes: nil)
        }
        let functionWithParenthesisRemoved = "\(function)".trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        switch scale {
        case .native:
            let path = "\(directoryWithImageType)/\(functionWithParenthesisRemoved)@\(Int(UIScreen.main.scale))x.png"
            return URL(fileURLWithPath: path)
        case .explicit(let scale):
            let path = "\(directoryWithImageType)/\(functionWithParenthesisRemoved)@\(Int(scale))x.png"
            return URL(fileURLWithPath: path)
        }
        
    }
    
}

extension UIView { // TODO: Move
    
    func image(withScale scale: PixelTestCase.Scale) -> UIImage? {
        let imageScale: CGFloat
        switch scale {
        case .native: imageScale = 0
        case .explicit(let explicitScale): imageScale = explicitScale
        }
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, imageScale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
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
