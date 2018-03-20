//
//  UIView+NibLoading.swift
//  PixelTest_Example
//
//  Created by Kane Cheshire on 20/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(classForCoder())", bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T>() -> T {
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
}
