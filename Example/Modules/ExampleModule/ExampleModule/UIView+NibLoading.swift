//
//  UIView+NibLoading.swift
//  ExampleModule
//
//  Created by Kane Cheshire on 21/10/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
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
