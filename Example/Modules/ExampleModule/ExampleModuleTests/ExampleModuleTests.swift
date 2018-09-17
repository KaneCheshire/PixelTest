//
//  ExampleModuleTests.swift
//  ExampleModuleTests
//
//  Created by Kane Cheshire on 17/09/2018.
//  Copyright © 2018 Kane Cheshire. All rights reserved.
//

import XCTest
import PixelTest
@testable import ExampleModule

class ExampleModuleTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test
    }
    
    func test_simpleView() {
        let view = SimpleView(frame: .zero)
        view.sizeToFit()
        verify(view, layoutStyle: .fixed(width: 310, height: 21))
    }
    
}
