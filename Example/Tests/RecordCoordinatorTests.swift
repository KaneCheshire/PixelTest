//
//  RecordCoordinatorTests.swift
//  PixelTest_Example
//
//  Created by Kane Cheshire on 14/10/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import XCTest
@testable import PixelTest

final class RecordCoordinatorTests: XCTestCase {

    private var recordCoordinator: RecordCoordinator!
    private var mockFileCoordinator: MockFileCoordinator!
    private let config = Config(function: #function, file: #file, line: #line, scale: .native, layoutStyle: .dynamicWidthHeight)
    private let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    private let url = URL(string: "file://something")
    
    override func setUp() {
        super.setUp()
        mockFileCoordinator = MockFileCoordinator()
        recordCoordinator = RecordCoordinator(fileCoordinator: mockFileCoordinator)
    }
    
    func test_noSnapshot() {
        do {
            _ = try recordCoordinator.record(UIView(), config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Record {
            XCTAssertEqual(error.localizedDescription, "Unable to create snapshot image")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_noWrite() {
        mockFileCoordinator.fileURLReturnValue = url
        mockFileCoordinator.writeError = CocoaError.error(.fileWriteUnknown)
        do {
            _ = try recordCoordinator.record(view, config: config)
            XCTFail()
        } catch let error as TestCoordinatorErrors.Record {
            XCTAssertEqual(error.localizedDescription, "Unable to write image to disk: The file couldn’t be saved.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_success() throws {
        mockFileCoordinator.fileURLReturnValue = url
        let image = try recordCoordinator.record(view, config: config)
        XCTAssertTrue(image.equalTo(view.image(withScale: .native)!))
    }

}
