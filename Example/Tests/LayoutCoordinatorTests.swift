//
//  LayoutCoordinatorTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 18/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class LayoutCoordinatorTests: XCTestCase {
    
    private var view: UIView!
    private var testLayoutCoordinator: LayoutCoordinator!
    
    override func setUp() {
        super.setUp()
        view = UIView()
        testLayoutCoordinator = LayoutCoordinator()
    }
    
    func test_dynamicWidth() {
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.constraints.isEmpty)
        testLayoutCoordinator.layOut(view, with: .dynamicWidth(fixedHeight: 100))
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(view.constraints.count, 1)
        XCTAssertEqual(view.constraints.first?.firstAnchor, view.heightAnchor)
        XCTAssertEqual(view.constraints.first?.constant, 100)
        XCTAssertNil(view.constraints.first?.secondAnchor)
    }
    
    func test_dynamicHeight() {
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.constraints.isEmpty)
        testLayoutCoordinator.layOut(view, with: .dynamicHeight(fixedWidth: 0.5))
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(view.constraints.count, 1)
        XCTAssertEqual(view.constraints.first?.firstAnchor, view.widthAnchor)
        XCTAssertEqual(view.constraints.first?.constant, 0.5)
        XCTAssertNil(view.constraints.first?.secondAnchor)
    }
    
    func test_dynamicWidthHeight() {
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.constraints.isEmpty)
        testLayoutCoordinator.layOut(view, with: .dynamicWidthHeight)
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(view.constraints.count, 0)
    }
    
    func test_fixedWidthAndHeight() {
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.constraints.isEmpty)
        testLayoutCoordinator.layOut(view, with: .fixed(width: 10, height: 320))
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(view.constraints.count, 2)
        XCTAssertEqual(view.constraints.first?.firstAnchor, view.widthAnchor)
        XCTAssertEqual(view.constraints.first?.constant, 10)
        XCTAssertNil(view.constraints.first?.secondAnchor)
        XCTAssertEqual(view.constraints.last?.firstAnchor, view.heightAnchor)
        XCTAssertEqual(view.constraints.last?.constant, 320)
        XCTAssertNil(view.constraints.last?.secondAnchor)
    }
    
}
