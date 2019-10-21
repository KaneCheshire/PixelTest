//
//  CustomTableViewHeaderViewSnapshotTests.swift
//  PixelTest_Example
//
//  Created by Kane Cheshire on 26/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import PixelTest
@testable import PixelTest_Example

class CustomTableViewHeaderViewSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_regularData() {
        let view: CustomTableViewHeaderView = .loadFromNib()
        let viewModel = CustomTableViewHeaderViewModel(title: "This is a title ")
        view.configure(with: viewModel)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
    func test_longData() {
        let view: CustomTableViewHeaderView = .loadFromNib()
        let viewModel = CustomTableViewHeaderViewModel(title: "This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title This is a title ")
        view.configure(with: viewModel)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
}
