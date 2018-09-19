//
//  UIImage+DiffImageTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class UIImage_DiffImageTests: XCTestCase {
    
    func test_usesLargestWidthHeight() {
        let view1 = UIView(frame: .init(x: 0, y: 0, width: 100, height: 20))
        let image1 = view1.image(withScale: .native)!
        let view2 = UIView(frame: .init(x: 0, y: 0, width: 50, height: 90))
        let image2 = view2.image(withScale: .native)!
        let diff1 = image1.diff(with: image2)!
        let diff2 = image2.diff(with: image1)!
        XCTAssertEqual(diff1.size, CGSize(width: 100, height: 90))
        XCTAssertEqual(diff2.size, CGSize(width: 100, height: 90))
    }
    
}
