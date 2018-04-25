//
//  CustomTableViewCell.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct CustomTableViewCellViewModel {
    
    let title: String
    let content: String
    
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentLabel: UILabel!
    
    func configure(with viewModel: CustomTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
    }
    
}
