//
//  UIColor+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import UIKit

extension UIColor {
    
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    /// Returns the RGB values.
    func rgbaValues() -> RGBA {
        var r: CGFloat = 0
        var b: CGFloat = 0
        var g: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBA(r, g, b, a)
    }
    
    /// Returns the RGB values adjusted according to WCAG guidelines.
    /// TODO: Link
    func wcagAdjustedRGBA() -> RGBA {
        let rgb = rgbaValues()
        return RGBA(rgb.red.wcagAdjustedValue(), rgb.green.wcagAdjustedValue(), rgb.blue.wcagAdjustedValue(), rgb.alpha)
    }
    
    /// Returns the relative luminosity of the color according to WCAG guidelines.
    func wcagLuminosity() -> CGFloat {
        let adjustedRGB = wcagAdjustedRGBA()
        return (0.2126 * adjustedRGB.red) + (0.7152 * adjustedRGB.green) + (0.0722 * adjustedRGB.blue)
    }
    
    /// Returns the contrast ratio compared to another color according to WCAG guidelines.
    /// E.g 1.5 represents 1.5:1 ratio.
    ///
    /// - Parameter color: The color to compare against.
    /// - Returns: The ratio.
    func wcagContrastRatio(comparedTo color: UIColor) -> CGFloat {
        let luminosity1 = (wcagLuminosity() * 100).rounded(.toNearestOrEven) / 100
        let luminosity2 = (color.wcagLuminosity() * 100).rounded(.toNearestOrEven) / 100
        let lightestLuminosity = max(luminosity1, luminosity2)
        let darkestLuminosity = min(luminosity1, luminosity2)
        let ratio = (lightestLuminosity + 0.05) / (darkestLuminosity + 0.05)
        return (ratio * 100).rounded(.toNearestOrEven) / 100
    }
    
}
