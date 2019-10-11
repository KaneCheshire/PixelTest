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
    
    func test_record_noSnapshot() {
        let result = testCoordinator.record(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
            case .success: XCTFail("Incorrect result: \(result)")
            case .failure(let failed): XCTAssertEqual(failed.errorMessage, "Unable to create snapshot image")
        }
    }
    
    func test_record_noWrite() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.writeError = CocoaError.error(.fileWriteUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.record(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
            case .success: XCTFail("Incorrect result: \(result)")
            case .failure(let failed): XCTAssertEqual(failed.errorMessage, "Unable to write image data to disk: The file couldn't be saved.")
        }
    }
    
    func test_record_success() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.record(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success(let image): XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
        case .failure: XCTFail("Incorrect result: \(result)")
        }
    }
    
    func test_test_noSnapshot() {
        let result = testCoordinator.test(UIView(), layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .failure(let error):
           XCTAssertEqual(error.errorMessage, "Unable to create snapshot image")
        }
    }
    
    func test_test_noRecordedData() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.dataError = CocoaError.error(.fileReadUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .failure(let error):
            XCTAssertEqual(error.errorMessage, "Unable to get recorded image data")
        }
    }
    
    func test_test_noRecordedImage() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .failure(let failed):
            XCTAssertEqual(failed.errorMessage, "Unable to get recorded image")
        }
    }
    
    func test_test_mismatch() {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 11)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success: XCTFail("Incorrect result: \(result)")
        case .failure(let error):
            switch error {
                case .imagesAreDifferent(reference: let reference, failed: let failed):
                    XCTAssertTrue(reference.equalTo(mockRecordedImage))
                    XCTAssertTrue(failed.equalTo(view.image(withScale: .native)!))
                    XCTAssertEqual(error.errorMessage, "Images are different")
                default: XCTFail("Unexpected result")
            }
           
        }
    }
    
    func test_test_success() {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let result = testCoordinator.test(view, layoutStyle: .dynamicWidthHeight, scale: .native, function: #function, file: #file)
        switch result {
        case .success(let image):
            XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
        case .failure: XCTFail("Incorrect result: \(result)")
        }
    }
    
}
