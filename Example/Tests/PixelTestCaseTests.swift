//
//  PixelTestCaseTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

final class PixelTestCaseTests: XCTestCase {
    
    private var testCase: PixelTestCase!
    private var mockLayoutCoordinator: MockLayoutCoordinator!
    private var mockTestCoordinator: MockTestCoordinator!
    private var mockFileCoordinator: MockFileCoordinator!
    
    override func setUp() {
        super.setUp()
        mockLayoutCoordinator = MockLayoutCoordinator()
        mockTestCoordinator = MockTestCoordinator()
        mockFileCoordinator = MockFileCoordinator()
        testCase = PixelTestCase(layoutCoordinator: mockLayoutCoordinator, testCoordinator: mockTestCoordinator, fileCoordinator: mockFileCoordinator)
    }
    
    func test_test_success() {
        testCase.mode = .test
        let testView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        testCase.verify(testView, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockLayoutCoordinator.layOutCallCount, 1)
        XCTAssertEqual(mockTestCoordinator.testCallCount, 1)
        XCTAssertEqual(mockFileCoordinator.removeDiffAndFailureImagesCallCount, 1)
        XCTAssertEqual(mockFileCoordinator.storeDiffImageCallCount, 0)
    }
    
}

class MockLayoutCoordinator: LayoutCoordinatorType {
    
    var layOutCallCount = 0
    var onLayOut: ((UIView, LayoutStyle) -> Void)?
    
    func layOut(_ view: UIView, with layoutStyle: LayoutStyle) {
        layOutCallCount += 1
        onLayOut?(view, layoutStyle)
    }
    
}

class MockTestCoordinator: TestCoordinatorType {
    
    var recordCallCount = 0
    var onRecord: ((UIView, Config) -> Void)?
    var recordErrorToThrow: Error?
    var recordReturnValue: UIImage!
    
    func record(_ view: UIView, config: Config) throws -> UIImage {
        recordCallCount += 1
        onRecord?(view, config)
        if let recordErrorToThrow = recordErrorToThrow {
            throw recordErrorToThrow
        }
        return recordReturnValue
    }
    
    var testCallCount = 0
    var onTest: ((UIView, Config) -> Void)?
    var testErrorToThrow: Error?
    
    func test(_ view: UIView, config: Config) throws {
        testCallCount += 1
        onTest?(view, config)
        if let testErrorToThrow = testErrorToThrow {
            throw testErrorToThrow
        }
    }
}

class MockFileCoordinator: FileCoordinatorType {
    
    
    var fileURLCallCount = 0
    var onFileURL: ((Config, ImageType) -> Void)?
    var fileURLReturnValue: URL!
    
    func fileURL(for config: Config, imageType: ImageType) -> URL {
        fileURLCallCount += 1
        onFileURL?(config, imageType)
        return fileURLReturnValue
    }
    
    var writeCallCount = 0
    var onWrite: ((Data, URL) -> Void)?
    var writeError: Error?
    
    func write(_ data: Data, to url: URL) throws {
        writeCallCount += 1
        onWrite?(data, url)
        if let writeError = writeError {
            throw writeError
        }
    }
    
    var dataCallCount = 0
    var onData: ((URL) -> Void)?
    var dataError: Error?
    var dataReturnValue: Data = Data()
    
    func data(at url: URL) throws -> Data {
        dataCallCount += 1
        onData?(url)
        if let dataError = dataError {
            throw dataError
        }
        return dataReturnValue
    }
    
    var storeDiffImageCallCount = 0
    var onStoreDiffImage: ((UIImage, UIImage, Config) -> Void)?
    
    func store(diffImage: UIImage, failedImage: UIImage, config: Config) {
        storeDiffImageCallCount += 1
        onStoreDiffImage?(diffImage, failedImage, config)
    }
    
    var removeDiffAndFailureImagesCallCount = 0
    var onRemoveDiffAndFailureImages: ((Config) -> Void)?
    
    func removeDiffAndFailureImages(config: Config) {
        removeDiffAndFailureImagesCallCount += 1
        onRemoveDiffAndFailureImages?(config)
    }
    
}
