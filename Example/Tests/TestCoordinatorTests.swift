//
//  TestCoordinatorTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 19/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

final class TestCoordinatorTests: XCTestCase {
    
    private var testCoordinator: TestCoordinator!
    private var mockFileCoordinator: MockFileCoordinator!
    private let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
    private let url = URL(string: "file://something")
    private let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override func setUp() {
        super.setUp()
        mockFileCoordinator = MockFileCoordinator()
        testCoordinator = TestCoordinator(fileCoordinator: mockFileCoordinator)
    }
    
    func test_noSnapshot() {
        do {
            let _ = try testCoordinator.test(UIView(), config: config)
            XCTFail()
        } catch let error as Errors.Test {
            XCTAssertEqual(error.localizedDescription, "Unable to create snapshot image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_noRecordedData() {
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.dataError = CocoaError.error(.fileReadUnknown)
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as Errors.Test {
            XCTAssertEqual(error.localizedDescription, "Unable to get recorded image data")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_noRecordedImage() {
        mockFileCoordinator.fileURLReturnValue = url
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as Errors.Test {
            XCTAssertEqual(error.localizedDescription, "Unable to get recorded image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_mismatch() {
        mockFileCoordinator.fileURLReturnValue = url
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 11)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
        do {
            let _ = try testCoordinator.test(view, config: config)
            XCTFail()
        } catch let error as Errors.Test {
            switch error {
                case .imagesAreDifferent(reference: let reference, failed: let failed):
                    XCTAssertTrue(reference.equalTo(mockRecordedImage))
                    XCTAssertTrue(failed.equalTo(view.image(withScale: .native)!))
                    XCTAssertEqual(error.localizedDescription, "Images are different (see attached diff/failure images in logs)")
                default: XCTFail("Unexpected result")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
        
    func test_success() throws {
        mockFileCoordinator.fileURLReturnValue = url
        let mockRecordedImage = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)).image(withScale: .native)!
        mockFileCoordinator.dataReturnValue = mockRecordedImage.pngData()!
        try testCoordinator.test(view, config: config)
    }
        
}
