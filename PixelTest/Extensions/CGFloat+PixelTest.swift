//
//  CGFloat+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import Foundation

extension CGFloat {
    
    /// Adjusts the value according to WCAG guidelines.
    /// https://www.w3.org/TR/WCAG20/relative-luminance.xml
    func wcagAdjustedValue() -> CGFloat {
        if self <= 0.03928 {
            return self / 12.92
        } else {
            return pow((self + 0.055) / 1.055, 2.4)
        }
    }
    
}
