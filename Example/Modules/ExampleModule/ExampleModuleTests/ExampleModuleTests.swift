//
//  ExampleModuleTests.swift
//  ExampleModuleTests
//
//  Created by Kane Cheshire on 09/10/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import PixelTest
@testable import ExampleModule

class ExampleModuleTests: PixelTestCase {

    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_view() {
        let view: ExampleModuleView = ExampleModuleView.loadFromNib()
        verify(view, layoutStyle: .dynamicHeight)
    }
    
}
