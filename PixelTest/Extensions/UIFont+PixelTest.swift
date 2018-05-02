//
//  UIFont+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 02/05/2018.
//

import UIKit

extension UIFont {
    
    /// Determines if the font is considered to be bold by the system.
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
}
