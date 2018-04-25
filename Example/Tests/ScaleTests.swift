//
//  ScaleTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 18/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class ScaleTests: XCTestCase {
    
    func test_explicitOrScreenNativeValue() {
        XCTAssertEqual(Scale.native.explicitOrScreenNativeValue, UIScreen.main.scale)
        XCTAssertEqual(Scale.explicit(123.45).explicitOrScreenNativeValue, 123.45)
    }
    
    func test_explicitOrCoreGraphicsValue() {
        XCTAssertEqual(Scale.native.explicitOrCoreGraphicsValue, 0)
        XCTAssertEqual(Scale.explicit(453.21).explicitOrScreenNativeValue, 453.21)
    }
    
}
