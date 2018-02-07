import UIKit
import XCTest
import PixelTest

class Tests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
//        mode = .record
    }
    
    func test_aView() throws {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        view.widthAnchor.constraint(equalToConstant: 500).isActive = true
        view.backgroundColor  = .red
        
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
        try verify(view)
    }
}

open class PixelTestCase: XCTestCase {
    
    public enum Scale {
        case native
        case explicit(CGFloat)
    }
    
    public enum Mode {
        case record
        case test
    }
    
    public enum Error: Swift.Error {
        case viewHasNoWidth
        case viewHasNoHeight
        case unableToCreateImage
        case noKeyWindow
        case unableToCreateFileURL
    }
    
    public var mode: Mode = .test
    
    func verify(_ view: UIView, scale: Scale = .explicit(1), file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws {
        guard let window = UIApplication.shared.keyWindow else { throw Error.noKeyWindow }
        window.addSubview(view)
        guard view.bounds.width != 0 else { throw Error.viewHasNoWidth }
        guard view.bounds.height != 0 else { throw Error.viewHasNoHeight }
        switch mode {
        case .record: try record(view, window: window, scale: scale, file: file, function: function)
        case .test: try test(view, window: window, scale: scale, file: file, function: function)
        }
    }
    
    private func record(_ view: UIView, window: UIWindow, scale: Scale, file: StaticString, function: StaticString, line: UInt = #line) throws {
        guard let url = try fileURL(forFunction: function, scale: scale) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = UIImagePNGRepresentation(image) ?? Data()
        try data.write(to: url, options: .atomic)
        XCTFail("Snapshot recorded, disable record mode and re-run tests to verify.", file: file, line: line)
    }
    
    private func test(_ view: UIView, window: UIWindow, scale: Scale, file: StaticString, function: StaticString, line: UInt = #line) throws {
        guard let url = try fileURL(forFunction: function, scale: scale) else { throw Error.unableToCreateFileURL }
        guard let image = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = try Data(contentsOf: url, options: .uncached)
        let imageScale: CGFloat
        switch scale {
        case .native: imageScale = UIScreen.main.scale
        case .explicit(let explicitScale): imageScale = explicitScale
        }
        let recordedImage = UIImage(data: data, scale: imageScale)!
        if !image.equalTo(recordedImage) {
            XCTFail("Snapshots do not match", file: file, line: line)
        }
    }
    
    private func fileURL(forFunction function: StaticString, scale: Scale) throws -> URL? {
        guard let directory = ProcessInfo.processInfo.environment["PIXEL_TESTS_DIR"] else { fatalError("Please set `PIXEL_TESTS_DIR` as an environment variable") }
        if !FileManager.default.fileExists(atPath: directory) {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        let functionWithParenthesisRemoved = "\(function)".trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        switch scale {
        case .native:
            let path = "\(directory)/\(functionWithParenthesisRemoved)@\(Int(UIScreen.main.scale))x.png"
            return URL(fileURLWithPath: path)
        case .explicit(let scale):
            let path = "\(directory)/\(functionWithParenthesisRemoved)@\(Int(scale))x.png"
            return URL(fileURLWithPath: path)
        }
       
    }
    
}

extension UIView {
    
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

extension UIImage {
    
    func equalTo(_ image: UIImage) -> Bool {
        guard size == image.size else { return false }
        return UIImagePNGRepresentation(self) == UIImagePNGRepresentation(image)
    }
    
}

