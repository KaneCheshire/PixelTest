//
//  PixelTestCaseTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 25/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class PixelTestCaseTests: XCTestCase {
    
    private var testCase: PixelTestCase!
    private var mockLayoutCoordinator: MockLayoutCoordinator!
    private var mockTestCoordinator: MockTestCoordinator!
    private var mockFileCoordinator: MockFileCoordinator!
    
    override func setUp() {
        super.setUp()
        mockLayoutCoordinator = MockLayoutCoordinator()
        mockTestCoordinator = MockTestCoordinator()
        mockFileCoordinator = MockFileCoordinator()
        testCase = PixelTestCase()
        testCase.layoutCoordinator = mockLayoutCoordinator
        testCase.testCoordinator = mockTestCoordinator
        testCase.fileCoordinator = mockFileCoordinator
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
    var onRecord: ((UIView, LayoutStyle, Scale, StaticString) -> Void)?
    var recordReturnValue: Result<UIImage, TestCoordinatorErrors.Record> = .success(UIImage())
    
    func record(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, function: StaticString, file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Record> {
        recordCallCount += 1
        onRecord?(view, layoutStyle, scale, function)
        return recordReturnValue
    }
    
    var testCallCount = 0
    var onTest: ((UIView, LayoutStyle, Scale, StaticString) -> Void)?
    var testReturnValue: Result<UIImage, TestCoordinatorErrors.Test> = .success(UIImage())
    
    func test(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, function: StaticString, file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Test> {
        testCallCount += 1
        onTest?(view, layoutStyle, scale, function)
        return testReturnValue
    }
}

class MockFileCoordinator: FileCoordinatorType {
    
    var fileURLCallCount = 0
    var onFileURL: ((StaticString, Scale, ImageType, LayoutStyle) -> Void)?
    var fileURLReturnValue: URL!
    
    func fileURL(for function: StaticString, file: StaticString, scale: Scale, imageType: ImageType, layoutStyle: LayoutStyle) -> URL {
        fileURLCallCount += 1
        onFileURL?(function, scale, imageType, layoutStyle)
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
    var onStoreDiffImage: ((UIImage, UIImage, StaticString, Scale, LayoutStyle) -> Void)?
    
    func storeDiffImage(_ diffImage: UIImage, failedImage: UIImage, function: StaticString, file: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        storeDiffImageCallCount += 1
        onStoreDiffImage?(diffImage, failedImage, function, scale, layoutStyle)
    }
    
    var removeDiffAndFailureImagesCallCount = 0
    var onRemoveDiffAndFailureImages: ((StaticString, Scale, LayoutStyle) -> Void)?
    
    func removeDiffAndFailureImages(function: StaticString, file: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        removeDiffAndFailureImagesCallCount += 1
        onRemoveDiffAndFailureImages?(function, scale, layoutStyle)
    }
    
}
