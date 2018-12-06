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
    
    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        testCoordinator = FileCoordinator(fileManager: mockFileManager)
    }
    
    // MARK: - Diff -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_diff_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_diff_dynamicWidthHeight/Diff/dw_dh@3.0x.png"))
    }
    
    func test_fileURL_nativeScale_diff_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_diff_dynamicWidth/Diff/dw_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_diff_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_diff_dynamicHeight/Diff/100.0_dh@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_diff_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_diff_fixedWidthHeight/Diff/100.0_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_diff_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_diff_dynamicWidthHeight/Diff/dw_dh@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_diff_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_diff_dynamicWidth/Diff/dw_100.0@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_diff_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .diff, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_diff_dynamicHeight/Diff/100.0_dh@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_diff_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .diff, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_diff_fixedWidthHeight/Diff/100.0_100.0@100.0x.png"))
    }
    
    // MARK: - Reference -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_reference_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .reference, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_reference_dynamicWidthHeight/Reference/dw_dh@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_reference_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .reference, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_reference_dynamicWidth/Reference/dw_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_reference_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .reference, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_reference_dynamicHeight/Reference/100.0_dh@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_reference_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .reference, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_reference_fixedWidthHeight/Reference/100.0_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_reference_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_reference_dynamicWidthHeight/Reference/dw_dh@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_reference_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_reference_dynamicWidth/Reference/dw_100.0@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_reference_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .reference, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_reference_dynamicHeight/Reference/100.0_dh@100.0x.png"))
        
    }
    
    func test_fileURL_explicitScale_reference_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .reference, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_reference_fixedWidthHeight/Reference/100.0_100.0@100.0x.png"))
    }
    
    // MARK: - Failure -
    // MARK: Native Scale
    
    func test_fileURL_nativeScale_failure_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .failure, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_failure_dynamicWidthHeight/Failure/dw_dh@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_failure_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .failure, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_failure_dynamicWidth/Failure/dw_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_failure_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .failure, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_failure_dynamicHeight/Failure/100.0_dh@\(UIScreen.main.scale)x.png"))
    }
    
    func test_fileURL_nativeScale_failure_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .failure, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_nativeScale_failure_fixedWidthHeight/Failure/100.0_100.0@\(UIScreen.main.scale)x.png"))
    }
    
    // MARK: Explicit scale
    
    func test_fileURL_explicitScale_failure_dynamicWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_failure_dynamicWidthHeight/Failure/dw_dh@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_failure_dynamicWidth() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicWidth(fixedHeight: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_failure_dynamicWidth/Failure/dw_100.0@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_failure_dynamicHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .failure, layoutStyle: .dynamicHeight(fixedWidth: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_failure_dynamicHeight/Failure/100.0_dh@100.0x.png"))
    }
    
    func test_fileURL_explicitScale_failure_fixedWidthHeight() {
        let url = testCoordinator.fileURL(for: #function, file: #file, scale: .explicit(100), imageType: .failure, layoutStyle: .fixed(width: 100, height: 100))
        XCTAssertEqual(url, URL(string: "\(currentFilePath()).pixeltest/snapshots/fileURL_explicitScale_failure_fixedWidthHeight/Failure/100.0_100.0@100.0x.png"))
    }
    
    // MARK: - Other tests -
    
    func test_createsBaseDirectory_whenDoesntExist() {
        observeDefaultFileExistsCalls()
        observeDefaultCreateDirectoryCalls()
        mockFileManager.fileExistsReturnValue = false
        _ = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 1)
        XCTAssertEqual(mockFileManager.createDirectoryCallCount, 1)
    }
    
    func test_doesntCreateBaseDirectory_whenExists() {
        observeDefaultFileExistsCalls()
        mockFileManager.fileExistsReturnValue = true
        _ = testCoordinator.fileURL(for: #function, file: #file, scale: .native, imageType: .diff, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 1)
        XCTAssertEqual(mockFileManager.createDirectoryCallCount, 0)
    }
    
    func test_removingDiffFailureImage() {
        mockFileManager.removeItemError = CocoaError.error(.featureUnsupported)
        mockFileManager.onRemoveItem = { url in
            switch (self.mockFileManager.removeItemCallCount, url) {
            case (1, URL(string: "\(self.currentFilePath()).pixeltest/snapshots/removingDiffFailureImage/Diff/dw_dh@\(UIScreen.main.scale)x.png")): XCTPass()
            case (2, URL(string: "\(self.currentFilePath()).pixeltest/snapshots/removingDiffFailureImage/Failure/dw_dh@\(UIScreen.main.scale)x.png")): XCTPass()
            default: XCTFail("Unepected URL \(url) for call \(self.mockFileManager.removeItemCallCount)")
            }
        }
        testCoordinator.removeDiffAndFailureImages(function: #function, file: #file, scale: .native, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.removeItemCallCount, 2)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 2)
    }
    
    func test_storingDiffFailureImage() {
        testCoordinator.storeDiffImage(UIImage(), failedImage: UIImage(), function: #function, file: #file, scale: .native, layoutStyle: .dynamicWidthHeight)
        XCTAssertEqual(mockFileManager.removeItemCallCount, 0)
        XCTAssertEqual(mockFileManager.fileExistsCallCount, 2)
    }
    
}

private extension FileCoordinatorTests {
    
    func observeDefaultFileExistsCalls(line: UInt = #line, file: StaticString = #file) {
        mockFileManager.onFileExists = { path in
            XCTAssertEqual(path, "\(self.currentFilePath()).pixeltest/snapshots/Diff/PixelTestCase", file: file, line: line)
        }
    }
    
    func observeDefaultCreateDirectoryCalls(line: UInt = #line, file: StaticString = #file) {
        mockFileManager.onCreateDirectory = { url, createIntermediateDirectories, optionalAttributes in
            XCTAssertNil(optionalAttributes)
            XCTAssertTrue(createIntermediateDirectories)
            XCTAssertEqual(url, URL(string: "file://something/something-else/PixelTestSnapshots/Diff/PixelTestCase"), file: file, line: line)
        }
    }
    
    func currentFilePath() -> String {
        var fileURL = URL(fileURLWithPath: "\(#file)")
        fileURL = fileURL.deletingLastPathComponent()
        return fileURL.absoluteString
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
 
}

func XCTPass() { // TODO: Move
    XCTAssert(true)
}
