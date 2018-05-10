//
//  UIImage+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import Foundation

extension UIImage {
    
    /// Determines if the image is equal to another image.
    ///
    /// - Parameter image: The other image.
    /// - Returns: `true` if the two images are identical.
    func equalTo(_ image: UIImage) -> Bool {
        guard size == image.size else { return false }
        return UIImagePNGRepresentation(self) == UIImagePNGRepresentation(image)
    }
    
    /// Creates a diff image betweeh the view and another image.
    ///
    /// - Parameter image: The other image.
    /// - Returns: A new image representing a diff of the two images, or nil if an image couldn't be created.
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
    
    /// Returns the average color of the image.
    /// Source: https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
    ///
    /// - Returns: The average color of the image, or nil if no color could be determined.
    func averageColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        guard let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]), let outputImage = filter.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [kCIContextWorkingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
}
