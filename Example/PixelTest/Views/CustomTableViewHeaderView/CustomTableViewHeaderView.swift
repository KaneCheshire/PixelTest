//
//  CustomTableViewHeaderView.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct CustomTableViewHeaderViewModel {
    
    let title: String
    
}

class CustomTableViewHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private var titleLabel: UILabel!
    
    func configure(with viewModel: CustomTableViewHeaderViewModel) {
        titleLabel.text = viewModel.title
    }
    
}
