//
//  UIView+PixelTestTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 08/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class UIView_PixelTestTests: XCTestCase {
    
    func test_allSubviews() {
        let viewA = UIView()
        let viewB1 = UIView()
        let viewB2 = UIView()
        let viewC1 = UIView()
        viewA.addSubview(viewB1)
        viewA.addSubview(viewB2)
        viewB2.addSubview(viewC1)
        XCTAssertEqual(viewA.allSubviews.count, 3)
        XCTAssertEqual(viewA.allSubviews, [viewB1, viewB2, viewC1])
    }
    
    func test_allLabels() {
        let viewA = UIView()
        let labelB1 = UILabel()
        let viewB2 = UIView()
        let labelC = UILabel()
        viewA.addSubview(labelB1)
        viewA.addSubview(viewB2)
        viewB2.addSubview(labelC)
        XCTAssertEqual(viewA.allLabels.count, 2)
        XCTAssertEqual(viewA.allLabels, [labelB1, labelC])
    }
    
}
