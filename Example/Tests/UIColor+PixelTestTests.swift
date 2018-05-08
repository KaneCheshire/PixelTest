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
    
    func test_rgbValues() {
        let color = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 0)
        XCTAssertEqual(color.rgbValues().r, 0.5)
        XCTAssertEqual(color.rgbValues().g, 0.6)
        XCTAssertEqual(color.rgbValues().b, 0.7)
    }
    
}
