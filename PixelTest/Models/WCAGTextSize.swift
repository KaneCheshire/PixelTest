//
//  WCAGTextSize.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import UIKit

/// Represents minimum text sizes defined by WCAG
/// TODO: Link
enum WCAGTextSize: CGFloat {
    
    /// A catch all for anything that doesn't fall under largeBold or largeRegular
    case normal = 0
    /// Bold text can be a minimum of 14pts to be considered large
    case largeBold = 14
    /// Regular text can be a minimum of 18pts to be considered large
    case largeRegular = 18
    
    init(for font: UIFont) {
        switch font.pointSize {
        case 0 ..< WCAGTextSize.largeBold.rawValue: self = .normal
        case WCAGTextSize.largeBold.rawValue ..< WCAGTextSize.largeRegular.rawValue where !font.isBold: self = .normal
        case WCAGTextSize.largeBold.rawValue ..< WCAGTextSize.largeRegular.rawValue where font.isBold: self = .largeBold
        default: self = .largeRegular
        }
    }
    
}
