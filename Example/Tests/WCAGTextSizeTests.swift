//
//  WCAGTextSizeTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 08/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class WCAGTextSizeTests: XCTestCase {
    
    func test_sizes() {
        XCTAssertEqual(WCAGTextSize.normal.rawValue, 0)
        XCTAssertEqual(WCAGTextSize.largeBold.rawValue, 14)
        XCTAssertEqual(WCAGTextSize.largeRegular.rawValue, 18)
    }
    
    func test_initForFont() {
        XCTAssertEqual(WCAGTextSize(for: .systemFont(ofSize: 0)), .normal)
        XCTAssertEqual(WCAGTextSize(for: .systemFont(ofSize: 13)), .normal)
        XCTAssertEqual(WCAGTextSize(for: .systemFont(ofSize: 14)), .normal)
        XCTAssertEqual(WCAGTextSize(for: .boldSystemFont(ofSize: 14)), .largeBold)
        XCTAssertEqual(WCAGTextSize(for: .systemFont(ofSize: 18)), .largeRegular)
        XCTAssertEqual(WCAGTextSize(for: .boldSystemFont(ofSize: 18)), .largeRegular)
        XCTAssertEqual(WCAGTextSize(for: .boldSystemFont(ofSize: 19)), .largeRegular)
    }
    
}
