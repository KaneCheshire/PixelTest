//
//  WCAGStandard.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import Foundation

/// Represents one of the WCAG standards (typically AA or AAA)
/// https://www.w3.org/TR/2008/REC-WCAG20-20081211/Overview.html#intro-layers-guidance
public enum WCAGStandard {
    
    case aa
    case aaa
    
    /// Returns the minimum contrast ratio required to pass validation for the provided text size.
    ///
    /// - Parameter textSize: The WCAG-defined text size.
    /// - Returns: The minimum contrast rastio required to pass validation.
    func minContrastRatio(for textSize: WCAGTextSize) -> CGFloat {
        switch (self, textSize) {
        case (.aa, .largeBold),
             (.aa, .largeRegular): return 3.1
        case (.aa, .normal),
             (.aaa, .largeBold),
             (.aaa, .largeRegular): return 4.5
        case (.aaa, .normal): return 7.1
        }
    }
    
    /// Returns appropriate display text for the standard.
    var displayText: String {
        switch self {
        case .aa: return "AA"
        case .aaa: return "AAA"
        }
    }
    
}
