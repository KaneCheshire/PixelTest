//
//  UIView+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import UIKit

extension UIView {
    
    /// Returns all subviews, including subviews of subviews, recursively.
    var allSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.allSubviews }
    }
    
    /// Returns all subviews that are labels, including subviews of subviews, recursively.
    var allLabels: [UILabel] {
        return allSubviews.compactMap { $0 as? UILabel }
    }
    
    /// Creates an image from the view's contents, using its layer.
    ///
    /// - Parameter scale: The scale of the image to create.
    /// - Returns: An image, or nil if an image couldn't be created.
    func image(withScale scale: Scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale.explicitOrCoreGraphicsValue)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Creates an image of the specified rect in the view, using its layer.
    ///
    /// - Parameters:
    ///   - rect: The rect of the image to create within the view.
    ///   - scale: The scale of the image to create.
    /// - Returns: An image, or nil if an image couldn't be created.
    func image(of rect: CGRect, with scale: Scale) -> UIImage? {
        guard let imageOfView = image(withScale: scale) else { return nil }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale.explicitOrCoreGraphicsValue)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        imageOfView.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Normalizes the background color by removing transparency.
    /// If the background color is nil or completely transparent, the fallback color is used.
    ///
    /// - Parameter fallbackColor: The fallback color to use if the background color is nil or completely transparent.
    /// - Returns: The original, un-manipulated background color.
    func normalizedBackgroundColor(with fallbackColor: UIColor) -> UIColor? {
        let originalBackgroundColor = backgroundColor
        let originalBackgroundColorAlpha = originalBackgroundColor?.rgbaValues().alpha ?? 0
        if originalBackgroundColorAlpha == 0 {
            backgroundColor = fallbackColor
        } else if originalBackgroundColorAlpha < 1 {
            backgroundColor = originalBackgroundColor?.withAlphaComponent(1)
        }
        return originalBackgroundColor
    }
}
