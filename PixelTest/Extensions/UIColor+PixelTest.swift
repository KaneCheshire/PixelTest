//
//  UIColor+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import UIKit

extension UIColor {
    
    typealias RGB = (r: CGFloat, g: CGFloat, b: CGFloat)
    
    /// Returns the RGB values.
    func rgbValues() -> RGB {
        var r: CGFloat = 0
        var b: CGFloat = 0
        var g: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
    
    /// Returns the RGB values adjusted according to WCAG guidelines.
    /// TODO: Link
    func wcagAdjustedRGB() -> RGB {
        let rgb = rgbValues()
        return RGB(rgb.r.wcagAdjustedValue(), rgb.g.wcagAdjustedValue(), rgb.b.wcagAdjustedValue())
    }
    
    /// Returns the relative luminosity of the color according to WCAG guidelines.
    func wcagLuminosity() -> CGFloat {
        let adjustedRGB = wcagAdjustedRGB()
        return (0.2126 * adjustedRGB.r) + (0.7152 * adjustedRGB.g) + (0.0722 * adjustedRGB.b)
    }
    
    /// Returns the contrast ratio compared to another color according to WCAG guidelines.
    /// E.g 1.5 represents 1.5:1 ratio.
    ///
    /// - Parameter color: The color to compare against.
    /// - Returns: The ratio.
    func wcagContrastRatio(comparedTo color: UIColor) -> CGFloat {
        let luminosity1 = wcagLuminosity()
        let luminosity2 = color.wcagLuminosity()
        let lightestLuminosity = max(luminosity1, luminosity2)
        let darkestLuminosity = min(luminosity1, luminosity2)
        let ratio = (lightestLuminosity + 0.05) / (darkestLuminosity + 0.05)
        return (ratio * 10).rounded() / 10
    }
    
}
