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
    let image: UIImage
    
}

final class SimpleView: UIView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    func configure(with viewModel: SimpleViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        imageView.image = viewModel.image
    }
    
}
