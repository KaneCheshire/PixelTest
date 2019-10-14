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
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            _ = try testCoordinator.record(UIView(), config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Record {
            XCTAssertEqual(error.errorMessage, "Unable to create snapshot image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_record_noWrite() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.writeError = CocoaError.error(.fileWriteUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            _ = try testCoordinator.record(view, config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Record {
            XCTAssertEqual(error.errorMessage, "Unable to write image to disk: The file couldn’t be saved.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_record_success() throws {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        let image = try testCoordinator.record(view, config: config)
        XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
    }
    
    func test_test_noSnapshot() {
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            let _ = try testCoordinator.test(UIView(), config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Test {
            XCTAssertEqual(error.errorMessage, "Unable to create snapshot image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_test_noRecordedData() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.dataError = CocoaError.error(.fileReadUnknown)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Test {
            XCTAssertEqual(error.errorMessage, "Unable to get recorded image data")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_test_noRecordedImage() {
        let url = URL(string: "file://something")
        mockFileCoordinator.fileURLReturnValue = url
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Test {
            XCTAssertEqual(error.errorMessage, "Unable to get recorded image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_test_mismatch() {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 11)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Test {
            switch error {
                case .imagesAreDifferent(reference: let reference, failed: let failed):
                    XCTAssertTrue(reference.equalTo(mockRecordedImage))
                    XCTAssertTrue(failed.equalTo(view.image(withScale: .native)!))
                    XCTAssertEqual(error.errorMessage, "Images are different (see attached diff/failure images in logs)")
                default: XCTFail("Unexpected result")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
        
    func test_test_success() throws {
        mockFileCoordinator.fileURLReturnValue = URL(string: "file://something")
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        try testCoordinator.test(view, config: config)
    }
        
}
