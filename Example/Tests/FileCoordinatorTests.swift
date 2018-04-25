//
//  FileCoordinatorTests.swift
//  PixelTest
//
//  Created by Kane Cheshire on 18/04/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

class FileCoordinatorTests: XCTestCase {
    
    private var testCoordinator: FileCoordinator!
    private var mockFileManager: MockFileManager!
    private var mockTargetBaseDirectoryCoordinator: MockTargetBaseDirectoryCoordinator!
    private var mockTestCase: PixelTestCase!
    
    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        mockTargetBaseDirectoryCoordinator = MockTargetBaseDirectoryCoordinator()
        mockTargetBaseDirectoryCoordinator.targetBaseDirectoryReturnValue = URL(string: "file://something/something-else")
        mockTestCase = PixelTestCase()
        testCoordinator = FileCoordinator(fileManager: mockFileManager,
                                          targetBaseDirectoryCoordinator: mockTargetBaseDirectoryCoordinator,
                                          pixelTestBaseDirectory: "file://dummy")
    }
    
    // MARK: - Diff -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_diff_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_nativeScale_diff_dynamicWidthHeight_dw_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_diff_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_nativeScale_diff_dynamicWidth_dw_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_diff_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_nativeScale_diff_dynamicHeight_100.0_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_diff_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_nativeScale_diff_fixedWidthHeight_100.0_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_diff_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_explicitScale_diff_dynamicWidthHeight_dw_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_diff_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_explicitScale_diff_dynamicWidth_dw_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_diff_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_explicitScale_diff_dynamicHeight_100.0_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_diff_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .diff, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/fileURL_explicitScale_diff_fixedWidthHeight_100.0_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: - Reference -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_reference_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .reference, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_nativeScale_reference_dynamicWidthHeight_dw_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_reference_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .reference, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_nativeScale_reference_dynamicWidth_dw_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_reference_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .reference, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_nativeScale_reference_dynamicHeight_100.0_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_reference_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .reference, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_nativeScale_reference_fixedWidthHeight_100.0_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_reference_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_explicitScale_reference_dynamicWidthHeight_dw_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_reference_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_explicitScale_reference_dynamicWidth_dw_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_reference_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_explicitScale_reference_dynamicHeight_100.0_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_reference_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .reference, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Reference/PixelTestCase/fileURL_explicitScale_reference_fixedWidthHeight_100.0_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: - Failure -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_failure_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .failure, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_nativeScale_failure_dynamicWidthHeight_dw_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_failure_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .failure, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_nativeScale_failure_dynamicWidth_dw_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_failure_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .failure, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_nativeScale_failure_dynamicHeight_100.0_dh@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_nativeScale_failure_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .failure, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_nativeScale_failure_fixedWidthHeight_100.0_100.0@\(UIScreen.main.scale)x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_failure_dynamicWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_explicitScale_failure_dynamicWidthHeight_dw_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_failure_dynamicWidth() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_explicitScale_failure_dynamicWidth_dw_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_failure_dynamicHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_explicitScale_failure_dynamicHeight_100.0_dh@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    func test_fileURL_explicitScale_failure_fixedWidthHeight() {
        observeDefaultTargetBaseDirectoryCalls()
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 0)
        let url = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .explicit(100), imageType: .failure, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/fileURL_explicitScale_failure_fixedWidthHeight_100.0_100.0@100.0x.png"))
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 1)
    }
    
    // MARK: - Other tests -
    
    func test_createsBaseDirectory_whenDoesntExist() {
        observeDefaultFileExistsCalls()
        observeDefaultCreateDirectoryCalls()
        mockFileManager.fileExistsReturnValue = false
        _ = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 1)
        XCTAssertEqual(mockFileManager.createDirectoryCallCount, 1)
    }
    
    func test_doesntCreateBaseDirectory_whenExists() {
        observeDefaultFileExistsCalls()
        mockFileManager.fileExistsReturnValue = true
        _ = testCoordinator.fileURL(for: mockTestCase, forFunction: #function, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 1)
        XCTAssertEqual(mockFileManager.createDirectoryCallCount, 0)
    }
    
    func test_removingDiffFailureImage() {
        mockFileManager.removeItemError = CocoaError.error(.featureUnsupported)
        mockFileManager.onRemoveItem = { url in
            switch (self.mockFileManager.removeItemCallCount, url) {
            case (1, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase/removingDiffFailureImage_dw_dh@\(UIScreen.main.scale)x.png")): XCTPass()
            case (2, URL(string: "file://something/something-else/PixelTestSnapshots/Failure/PixelTestCase/removingDiffFailureImage_dw_dh@\(UIScreen.main.scale)x.png")): XCTPass()
            default: XCTFail("Unepected URL \(url) for call \(self.mockFileManager.removeItemCallCount)")
            }
        }
        testCoordinator.removeDiffAndFailureImages(for: mockTestCase, function: #function, scale: .native, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.removeItemCallCount, 2)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 2)
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 2)
    }
    
    func test_storingDiffFailureImage() {
        testCoordinator.storeDiffImage(UIImage(), failedImage: UIImage(), for: mockTestCase, function: #function, scale: .native, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.removeItemCallCount, 0)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 2)
        XCTAssertEqual(mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, 2)
    }
    
}

private extension FileCoordinatorTests {
    
    func observeDefaultTargetBaseDirectoryCalls(line: UInt = #line, file: StaticString = #file) {
        mockTargetBaseDirectoryCoordinator.onTargetBaseDirectory = { pixelTestCase, pixelTestBasePath in
            switch (self.mockTargetBaseDirectoryCoordinator.targetBaseDirectoryCallCount, pixelTestCase, pixelTestBasePath) {
            case (1, self.mockTestCase, "file://dummy"): XCTPass()
            default: XCTFail("Unexpected call configuration", file: file, line: line)
            }
        }
    }
    
    func observeDefaultFileExistsCalls(line: UInt = #line, file: StaticString = #file) {
        mockFileManager.onFileExists = { path in
            XCTAssertEqual(path, "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase", file: file, line: line)
        }
    }
    
    func observeDefaultCreateDirectoryCalls(line: UInt = #line, file: StaticString = #file) {
        mockFileManager.onCreateDirectory = { url, createIntermediateDirectories, optionalAttributes in
            XCTAssertNil(optionalAttributes)
            XCTAssertTrue(createIntermediateDirectories)
            XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase"), file: file, line: line)
        }
    }
    
}

private extension FileCoordinatorTests {
    
    class MockFileManager: FileManagerType {
        
        var fileExistsCallCount = 0
        var onFileExists: ((String) -> Void)?
        var fileExistsReturnValue = false
        
        func fileExists(atPath path: String) -> Bool {
            fileExistsCallCount += 1
            onFileExists?(path)
            return fileExistsReturnValue
        }
        
        var createDirectoryCallCount = 0
        var onCreateDirectory: ((URL, Bool, [FileAttributeKey: Any]?) -> Void)?
        
        func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
            createDirectoryCallCount += 1
            onCreateDirectory?(url, createIntermediates, attributes)
        }
        
        var enumeratorCallCount = 0
        var onEnumerator: ((String) -> Void)?
        var eumeratorReturnValue: FileManager.DirectoryEnumerator?
        
        func enumerator(atPath path: String) -> FileManager.DirectoryEnumerator? {
            enumeratorCallCount += 1
            onEnumerator?(path)
            return eumeratorReturnValue
        }
        
        var removeItemCallCount = 0
        var onRemoveItem: ((URL) -> Void)?
        var removeItemError: Error?
        
        func removeItem(at URL: URL) throws {
            removeItemCallCount += 1
            onRemoveItem?(URL)
            if let error = removeItemError {
                throw error
            }
        }
        
    }
    
    class MockTargetBaseDirectoryCoordinator: TargetBaseDirectoryCoordinatorType {
        
        var targetBaseDirectoryCallCount = 0
        var onTargetBaseDirectory: ((PixelTestCase, String) -> Void)?
        var targetBaseDirectoryReturnValue: URL?
        
        func targetBaseDirectory(for testCase: PixelTestCase, pixelTestBaseDirectory: String) -> URL? {
            targetBaseDirectoryCallCount += 1
            onTargetBaseDirectory?(testCase, pixelTestBaseDirectory)
            return targetBaseDirectoryReturnValue
        }
        
    }
 
}

func XCTPass() {
    XCTAssert(true)
}
