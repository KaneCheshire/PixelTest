//
//  NSObject+ModuleTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 18/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class NSObject_ModuleTests: XCTestCase {
    
    func test_moduleName() {
        XCTAssertEqual(PixelTestCase().module.name, "PixelTest")
        XCTAssertEqual(self.module.name, "PixelTest_Tests")
    }
    
    func test_className() {
        XCTAssertEqual(PixelTestCase().className, "PixelTestCase")
        XCTAssertEqual(self.className, "NSObject_ModuleTests")
    }
    
}


