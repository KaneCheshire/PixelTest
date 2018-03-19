//
//  PixelTestCaseTests.swift
//  PixelTest_Tests
//
//  Created by Kane Cheshire on 19/03/2018.
//  Copyright © 2018 Kane Cheshire. All rights reserved.
//

import XCTest
@testable import PixelTest

class PixelTestCaseTests: XCTestCase {
    
    private var baseDir = ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"]!
    
    func test_createsBaseDirectory_ifDoesntExist() throws {
        let testCase = MockPixelTestCase()
        let fileManager = MockFileManager()
        fileManager.fileExists = false
        XCTAssertEqual(fileManager.fileExistsCallCount, 0)
        XCTAssertEqual(fileManager.createDirectoryCallCount, 0)
        _ = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .dynamicWidthHeight, fileManager: fileManager)
        XCTAssertEqual(fileManager.fileExistsCallCount, 1)
        XCTAssertEqual(fileManager.createDirectoryCallCount, 1)
    }
    
    func test_doesntCreateBaseDirectory_ifExists() throws {
        let testCase = MockPixelTestCase()
        let fileManager = MockFileManager()
        fileManager.fileExists = true
        XCTAssertEqual(fileManager.fileExistsCallCount, 0)
        XCTAssertEqual(fileManager.createDirectoryCallCount, 0)
        _ = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .dynamicWidthHeight, fileManager: fileManager)
        XCTAssertEqual(fileManager.fileExistsCallCount, 1)
        XCTAssertEqual(fileManager.createDirectoryCallCount, 0)
    }
    
    func test_fileURL_reference_explicit_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(10), imageType: .reference, option: .dynamicWidthHeight, fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_explicit_dynamicWidthHeight_dw_dh@10.0x.png")
    }
    
    func test_fileURL_reference_explicit_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(10.1), imageType: .reference, option: .dynamicWidth(fixedHeight: 300), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_explicit_dynamicWidth_dw_300.0@10.1x.png")
    }
    
    func test_fileURL_reference_explicit_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(10.2), imageType: .reference, option: .dynamicHeight(fixedWidth: 300), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_explicit_dynamicHeight_300.0_dh@10.2x.png")
    }
    
    func test_fileURL_reference_explicit_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(10.3), imageType: .reference, option: .fixed(width: 10, height: 20), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_explicit_fixedWidthHeight_10.0_20.0@10.3x.png")
    }
    
    func test_fileURL_diff_explicit_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(1), imageType: .diff, option: .dynamicWidthHeight, fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_explicit_dynamicWidthHeight_dw_dh@1.0x.png")
    }
    
    func test_fileURL_diff_explicit_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(2), imageType: .diff, option: .dynamicWidth(fixedHeight: 1), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_explicit_dynamicWidth_dw_1.0@2.0x.png")
    }
    
    func test_fileURL_diff_explicit_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(3), imageType: .diff, option: .dynamicHeight(fixedWidth: 2), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_explicit_dynamicHeight_2.0_dh@3.0x.png")
    }
    
    func test_fileURL_diff_explicit_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(4), imageType: .diff, option: .fixed(width: 3, height: 4), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_explicit_fixedWidthHeight_3.0_4.0@4.0x.png")
    }
    
    func test_fileURL_failure_explicit_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(100), imageType: .failure, option: .dynamicWidthHeight, fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_explicit_dynamicWidthHeight_dw_dh@100.0x.png")
    }
    
    func test_fileURL_failure_explicit_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(200), imageType: .failure, option: .dynamicWidth(fixedHeight: 10), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_explicit_dynamicWidth_dw_10.0@200.0x.png")
    }
    
    func test_fileURL_failure_explicit_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(300), imageType: .failure, option: .dynamicHeight(fixedWidth: 20), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_explicit_dynamicHeight_20.0_dh@300.0x.png")
    }
    
    func test_fileURL_failure_explicit_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .explicit(400), imageType: .failure, option: .fixed(width: 30, height: 40), fileManager: fileManager)
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_explicit_fixedWidthHeight_30.0_40.0@400.0x.png")
    }
    
    func test_fileURL_reference_native_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .reference, option: .dynamicWidthHeight, fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_native_dynamicWidthHeight_dw_dh@\(scale)x.png")
    }
    
    func test_fileURL_reference_native_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .reference, option: .dynamicWidth(fixedHeight: 300), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_native_dynamicWidth_dw_300.0@\(scale)x.png")
    }
    
    func test_fileURL_reference_native_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .reference, option: .dynamicHeight(fixedWidth: 300), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_native_dynamicHeight_300.0_dh@\(scale)x.png")
    }
    
    func test_fileURL_reference_native_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .reference, option: .fixed(width: 10, height: 20), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Reference/PixelTestCaseTests/test_fileURL_reference_native_fixedWidthHeight_10.0_20.0@\(scale)x.png")
    }
    
    func test_fileURL_diff_native_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .dynamicWidthHeight, fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_native_dynamicWidthHeight_dw_dh@\(scale)x.png")
    }
    
    func test_fileURL_diff_native_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .dynamicWidth(fixedHeight: 1), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_native_dynamicWidth_dw_1.0@\(scale)x.png")
    }
    
    func test_fileURL_diff_native_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .dynamicHeight(fixedWidth: 2), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_native_dynamicHeight_2.0_dh@\(scale)x.png")
    }
    
    func test_fileURL_diff_native_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .diff, option: .fixed(width: 3, height: 4), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Diff/PixelTestCaseTests/test_fileURL_diff_native_fixedWidthHeight_3.0_4.0@\(scale)x.png")
    }
    
    func test_fileURL_failure_native_dynamicWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .failure, option: .dynamicWidthHeight, fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_native_dynamicWidthHeight_dw_dh@\(scale)x.png")
    }
    
    func test_fileURL_failure_native_dynamicWidth() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .failure, option: .dynamicWidth(fixedHeight: 10), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_native_dynamicWidth_dw_10.0@\(scale)x.png")
    }
    
    func test_fileURL_failure_native_dynamicHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .failure, option: .dynamicHeight(fixedWidth: 20), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_native_dynamicHeight_20.0_dh@\(scale)x.png")
    }
    
    func test_fileURL_failure_native_fixedWidthHeight() throws {
        let fileManager = MockFileManager()
        let testCase = MockPixelTestCase()
        let fileURL = try testCase.fileURL(forFunction: #function, scale: .native, imageType: .failure, option: .fixed(width: 30, height: 40), fileManager: fileManager)
        let scale = UIScreen.main.scale
        XCTAssertEqual(fileURL.relativePath, baseDir + "/PixelTest_TestsSnapshots/Failure/PixelTestCaseTests/test_fileURL_failure_native_fixedWidthHeight_30.0_40.0@\(scale)x.png")
    }
    
}

private extension PixelTestCaseTests {
    
    class MockPixelTestCase: PixelTestCase {
        
    }
    
    class MockFileManager: FileManagerType {
        
        var fileExists: Bool = false
        var fileExistsCallCount = 0
        
        func fileExists(atPath path: String) -> Bool {
            fileExistsCallCount += 1
            return fileExists
        }
        
        var createDirectoryCallCount = 0
        
        func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
            createDirectoryCallCount += 1
        }
        
    }
    
}
