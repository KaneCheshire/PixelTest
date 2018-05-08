//
//  WCAGStandardTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 08/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class WCAGStandardTests: XCTestCase {
    
    func test_minContrastRatio_aa() {
        XCTAssertEqual(WCAGStandard.aa.minContrastRatio(for: .normal), 4.5)
        XCTAssertEqual(WCAGStandard.aa.minContrastRatio(for: .largeBold), 3.1)
        XCTAssertEqual(WCAGStandard.aa.minContrastRatio(for: .largeRegular), 3.1)
    }
    
    func test_minContrastRatio_aaa() {
        XCTAssertEqual(WCAGStandard.aaa.minContrastRatio(for: .normal), 7.1)
        XCTAssertEqual(WCAGStandard.aaa.minContrastRatio(for: .largeBold), 4.5)
        XCTAssertEqual(WCAGStandard.aaa.minContrastRatio(for: .largeRegular), 4.5)
    }
    
    func test_displayTest() {
        XCTAssertEqual(WCAGStandard.aa.displayText, "AA")
        XCTAssertEqual(WCAGStandard.aaa.displayText, "AAA")
    }
    
}
