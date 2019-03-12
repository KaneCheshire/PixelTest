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
        return self.pngData() == image.pngData()
    }
    
    /// Creates a diff image between the view and another image.
    ///
    /// - Parameter image: The other image
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
    
    /// Creates an image by clipping it from top.
    ///
    /// - Parameter fromTop: Size to clip from top.
    /// - Returns: Clipped image.
    func clip(fromTop top: Int) -> UIImage? {
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        let rect = CGRect(
            x: 0,
            y: top,
            width: cgImage.width,
            height: cgImage.height - top
        )
        
        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: imageOrientation)
        }
        
        return nil
    }
    
}

extension UIImage: Imageable {
    
    /// Creates a scaled image from the current instance.
    ///
    /// - Parameter scale: The scale of the image to create.
    /// - Returns: An image, or nil if an image couldn't be created.
    public func image(withScale scale: Scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale.explicitOrCoreGraphicsValue)
        draw(at: CGPoint.zero)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}
