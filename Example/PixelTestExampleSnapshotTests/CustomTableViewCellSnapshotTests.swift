//
//  CustomTableViewCellSnapshotTests.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import PixelTest
@testable import PixelTest_Example

import XCTest
class CustomTableViewCellSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_regularData() {
        let viewModel = CustomTableViewCellViewModel(title: "The best title", content: "Some amazing content")
        let view: CustomTableViewCell = .loadFromNib()
        view.configure(with: viewModel)
        verifyColourContrast(for: view.contentView, layoutStyle: .dynamicHeight320Width, standard: .aa)
    }
    
    func test_longData() {
        let viewModel = CustomTableViewCellViewModel(title: "The best title The best title The best title The best title The best title The best title", content: "Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content Some amazing content")
        let view: CustomTableViewCell = .loadFromNib()
        view.configure(with: viewModel)
        verify(view.contentView, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
    
}
