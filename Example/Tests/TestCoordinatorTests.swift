//
//  TestCoordinatorTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 19/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class TestCoordinatorTests: XCTestCase {
    
    private var testCoordinator: TestCoordinator!
    private var mockFileCoordinator: MockFileCoordinator!
    
    override func setUp() {
        super.setUp()
        mockFileCoordinator = MockFileCoordinator()
        testCoordinator = TestCoordinator(fileCoordinator: mockFileCoordinator)
    }
    
    func test_record_noURL() {
        let result = testCoordinator.record(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed): XCTAssertEqual(failed, "Unable to get URL")
        }
    }
    
    func test_record_noSnapshot() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let result = testCoordinator.record(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed): XCTAssertEqual(failed, "Unable to create snapshot")
        }
    }
    
    func test_record_noWrite() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.writeError = CocoaError.error(.fileWriteUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.record(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed): XCTAssertEqual(failed, "Unable to write image data to disk")
        }
    }
    
    func test_record_success() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.record(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success(let image): XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
        case .fail: XCTFail("Incorrect result: \(result)")
        }
    }
    
    func test_test_noURL() {
        let result = testCoordinator.test(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, testCase: .init(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed):
            XCTAssertEqual(failed.message, "Unable to get URL")
            XCTAssertNil(failed.oracle)
            XCTAssertNil(failed.test)
        }
    }
    
    func test_test_noSnapshot() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let result = testCoordinator.test(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed):
            XCTAssertEqual(failed.message, "Unable to create snapshot")
            XCTAssertNil(failed.oracle)
            XCTAssertNil(failed.test)
        }
    }
    
    func test_test_noRecordedData() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.dataError = CocoaError.error(.fileReadUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed):
            XCTAssertEqual(failed.message, "Unable to get recorded image data")
            XCTAssertNil(failed.oracle)
            XCTAssertNil(failed.test)
        }
    }
    
    func test_test_noRecordedImage() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed):
            XCTAssertEqual(failed.message, "Unable to get recorded image")
            XCTAssertNil(failed.oracle)
            XCTAssertNil(failed.test)
        }
    }
    
    func test_test_mismatch() {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 11)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = UIImagePNGRepresentation(mockRecordedImage)!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .fail(let failed):
            XCTAssertEqual(failed.message, "Snapshot test failed, images are different")
            XCTAssertTrue(failed.oracle!.equalTo(mockRecordedImage))
            XCTAssertTrue(failed.test!.equalTo(view.image(withScale: .native)!))
        }
    }
    
    func test_test_success() {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = UIImagePNGRepresentation(mockRecordedImage)!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, testCase: PixelTestCase(), function: #function)
        switch result {
        case .success(let image):
            XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
        case .fail: XCTFail("Incorrect result: \(result)")
        }
    }
    
}
