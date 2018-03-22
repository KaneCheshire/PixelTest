//
//  DynamicTypeViewSnapshotTests.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 20/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import PixelTest
@testable import PixelTest_Example

// Depending on how you set your font system up, you can use snapshot testing to test how your layout handles multiple font sizes.

class DynamicTypeViewSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_standardSize() throws {
        let view: DynamicTypeView = .loadFromNib()
        let viewModel = DynamicTypeViewModel(text: "Hello world")
        let traitCollection = UITraitCollection(preferredContentSizeCategory: .medium)
        view.configure(with: viewModel, traitCollection: traitCollection)
        try verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
    
    func test_accessibilityExtraExtraExtraLargeSize() throws {
        let view: DynamicTypeView = .loadFromNib()
        let viewModel = DynamicTypeViewModel(text: "Hello world")
        let traitCollection = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        view.configure(with: viewModel, traitCollection: traitCollection)
        try verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
}
