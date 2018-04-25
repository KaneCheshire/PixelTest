//
//  DynamicTypeView.swift
//  PixelTest
//
//  Created by Kane Cheshire on 20/03/2018.
//Copyright © 2018 kane.codes. All rights reserved.
//

import UIKit

struct DynamicTypeViewModel {
    
    let text: String
    
}

final class DynamicTypeView: UIView {

    @IBOutlet private var label: UILabel!
    
    func configure(with viewModel: DynamicTypeViewModel, traitCollection: UITraitCollection? = UIApplication.shared.keyWindow?.traitCollection) {
        label.text = viewModel.text
        configureFonts(with: traitCollection)
    }
    
    private func configureFonts(with traitCollection: UITraitCollection?) {
        let baseFont = UIFont.boldSystemFont(ofSize: 17)
        if #available(iOS 11.0, *) {
            label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont, compatibleWith: traitCollection)
        }
    }
    
}
