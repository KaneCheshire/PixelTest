//
//  BoundingSizeTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 19/03/2018.
//  Copyright © 2018 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest
@testable import PixelTest_Example
@testable import PixelTest

class BoundingSizeTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .record
    }
    
    func test_simpleView_regularData() throws {
        let view: SimpleView = .init()
//        let viewModel = SimpleViewModel(title: "Hello World", subtitle: "This is a simple test")
//        view.configure(with: viewModel)
//        try verify(view, option: .dynamicHeight(fixedWidth: 320))
    }
    
    func test_regularSize() throws {
        try verifyView(with: .fixed(width: 100, height: 100))
    }
    
    func test_pointZeroOne_width() throws {
        try verifyView(with: .fixed(width: 100.01, height: 100))
    }
    
    func test_pointNineNine_width() throws {
        try verifyView(with: .fixed(width: 100.99, height: 100))
    }
    
    func test_pointTwoFive_width() throws {
        try verifyView(with: .fixed(width: 100.25, height: 100))
    }
    
    func test_pointSevenFive_width() throws {
        try verifyView(with: .fixed(width: 100.75, height: 100))
    }
    
    func test_pointFive_width() throws {
        try verifyView(with: .fixed(width: 100.5, height: 100))
    }
    
    func test_pointZeroOne_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.01))
    }
    
    func test_pointNineNine_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.99))
    }
    
    func test_pointFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.5))
    }
    
    func test_pointTwoFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.25))
    }
    
    func test_pointSevenFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.75))
    }
    
}

extension BoundingSizeTests {
    
    private func verifyView(with option: Option, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws {
        let view = UILabel()
        view.backgroundColor = .red
//        view.text = "Hello World!" // Uncomment to make tests fail
        try verify(view, option: option, file: file, function: function, line: line)
    }
    
}

