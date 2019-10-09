//
//  SimpleView.swift
//  PixelTest_Example
//
//  Created by Kane Cheshire on 20/03/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
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
//        layer.cornerRadius = 15
//        backgroundColor = .red
//        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
