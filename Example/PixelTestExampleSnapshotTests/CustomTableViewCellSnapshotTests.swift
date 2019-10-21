//
//  CustomTableViewCellSnapshotTests.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import PixelTest
@testable import PixelTest_Example

class CustomTableViewCellSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_regularData() {
        let viewModel = CustomTableViewCellViewModel(title: .shortContent, content: .shortContent)
        let view: CustomTableViewCell = .loadFromNib()
        view.configure(with: viewModel)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
    func test_longData() {
        let viewModel = CustomTableViewCellViewModel(title: .longContent, content: .veryLongContent)
        let view: CustomTableViewCell = .loadFromNib()
        view.configure(with: viewModel)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
}
