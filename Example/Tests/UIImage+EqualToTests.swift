//
//  UIImage+EqualToTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class UIImage_EqualToTests: XCTestCase {
    
    func test_imagesEqual() {
        let view1 = UIView(frame: .init(x: 0, y: 0, width: 100000, height: 1.5))
        let view2 = UIView(frame: .init(x: 0, y: 0, width: 100000, height: 1.5))
        let image1 = view1.image(withScale: .native)!
        let image2 = view2.image(withScale: .native)!
        XCTAssertTrue(image1.equalTo(image2))
    }
    
    func test_imagesNotEqual() {
        let view1 = UIView(frame: .init(x: 0, y: 0, width: 100000, height: 1.5))
        view1.backgroundColor = .red
        let view2 = UIView(frame: .init(x: 0, y: 0, width: 100000, height: 1.5))
        view2.backgroundColor = .green
        let image1 = view1.image(withScale: .native)!
        let image2 = view2.image(withScale: .native)!
        XCTAssertFalse(image1.equalTo(image2))
    }
    
}
