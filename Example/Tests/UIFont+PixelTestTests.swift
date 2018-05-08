//
//  UIFont+PixelTestTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 08/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class UIFont_PixelTestTests: XCTestCase {
    
    func test_isBold() {
        XCTAssertTrue(UIFont.boldSystemFont(ofSize: 1).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1, weight: .ultraLight).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1, weight: .thin).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1, weight: .light).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1, weight: .regular).isBold)
        XCTAssertFalse(UIFont.systemFont(ofSize: 1, weight: .medium).isBold)
        XCTAssertTrue(UIFont.systemFont(ofSize: 1, weight: .semibold).isBold)
        XCTAssertTrue(UIFont.systemFont(ofSize: 1, weight: .bold).isBold)
        XCTAssertTrue(UIFont.systemFont(ofSize: 1, weight: .heavy).isBold)
        XCTAssertTrue(UIFont.systemFont(ofSize: 1, weight: .black).isBold)
        let boldDescriptor = UIFontDescriptor().withSymbolicTraits(.traitBold)
        XCTAssertTrue(UIFont(descriptor: boldDescriptor!, size: 1).isBold)
        let notBoldDescriptor = UIFontDescriptor().withSymbolicTraits(.traitItalic)
        XCTAssertFalse(UIFont(descriptor: notBoldDescriptor!, size: 1).isBold)
    }
    
}
