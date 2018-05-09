//
//  UIColor+PixelTestTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 08/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class UIColor_PixelTestTests: XCTestCase {
    
    func test_rgbaValues() {
        let color = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 0.01)
        XCTAssertEqual(color.rgbaValues().red, 0.5)
        XCTAssertEqual(color.rgbaValues().green, 0.6)
        XCTAssertEqual(color.rgbaValues().blue, 0.7)
        XCTAssertEqual(color.rgbaValues().alpha, 0.01)
    }
    
}
