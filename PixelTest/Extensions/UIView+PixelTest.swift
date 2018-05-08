//
//  UIView+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import UIKit

extension UIView {
    
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
    
    /// Returns all subviews, including subviews of subviews, recursively.
    var allSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.allSubviews }
    }
    
    /// Returns all subviews that are labels, including subviews of subviews, recursively.
    var allLabels: [UILabel] {
        return allSubviews.compactMap { $0 as? UILabel }
    }
    
    
}
