//
//  SimpleView.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//  Copyright © 2018 Kane Cheshire. All rights reserved.
//

import UIKit

struct SimpleViewModel {
    
    let title: String
    let subtitle: String
    
}

/// A simple view with a title and subtitle,
/// where the title has one line, the subtitle has multiple lines.
final class SimpleView: UIView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    func configure(with viewModel: SimpleViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
}

//extension UIView {
//    
//    static func loadFromNib<T>() -> T {
//        let name = "\(classForCoder())"
//        let bundle = Bundle(for: self)
//        let nib = UINib(nibName: name, bundle: bundle)
//        return nib.instantiate(withOwner: nil, options: nil)[0] as! T
//    }
//    
//}

