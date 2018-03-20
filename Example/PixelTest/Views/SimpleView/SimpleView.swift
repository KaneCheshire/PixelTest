//
//  SimpleView.swift
//  PixelTest_Example
//
//  Created by Kane Cheshire on 20/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct SimpleViewModel {
    
    let title: String
    let subtitle: String
    
}

final class SimpleView: UIView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    func configure(with viewModel: SimpleViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
}

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(classForCoder())", bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T>() -> T {
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
}
