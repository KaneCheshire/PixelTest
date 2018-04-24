//
//  LayoutStyleTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 19/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import PixelTest

class LayoutStyleTests: XCTestCase {
    
    func test_fileValue() {
        XCTAssertEqual(LayoutStyle.dynamicWidth(fixedHeight: 10).fileValue, "dw_10.0")
        XCTAssertEqual(LayoutStyle.dynamicHeight(fixedWidth: 0.5555).fileValue, "0.5555_dh")
        XCTAssertEqual(LayoutStyle.dynamicWidthHeight.fileValue, "dw_dh")
        XCTAssertEqual(LayoutStyle.fixed(width: 321, height: 123.5).fileValue, "321.0_123.5")
    }
    
}
