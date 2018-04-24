//
//  PixelTestCase.swift
//  PixelTest
//
//  Created by Kane Cheshire on 13/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest

/// Subclass `PixelTestCase` after `import PixelTest`
open class PixelTestCase: XCTestCase {
    
    /// Represents an error that could occur specific to `PixelTestCase`.
    ///
    /// - viewHasNoWidth: The view provided has no width so cannot be verified.
    /// - viewHasNoHeight: The view provided has no height so canot be verified.
    /// - unableToCreateImage: The test case was unable to create an image for recording or testing.
    /// - noKeyWindow: The tests were unable to find a key window for the shared application, which is needed for snapshotting.
    /// - unableToCreateFileURL: The tests were unable to create a file URL required for testing.
    public enum Error: Swift.Error {
        case viewHasNoWidth
        case viewHasNoHeight
        case unableToCreateImage
        case unableToCreateFileURL
    }
    
    // MARK: - Properties -
    // MARK: Open
    
    open var mode: Mode = .test
    
    // MARK: Internal
    
    var layoutCoordinator = LayoutCoordinator()
    var testCoordinator = TestCoordinator()
    var fileCoordinator = FileCoordinator()
    
    // MARK: - Functions -
    
    /// Verifies a view.
    /// If this is called while in record mode, a new snapshot are recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - layoutStyle: The layout style to verify the view with.
    ///   - scale: The scale to record/test the snapshot with.
    open func verify(_ view: UIView, layoutStyle: LayoutStyle,
                     scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        layoutCoordinator.layOut(view, with: layoutStyle)
        guard view.bounds.width != 0 else { return XCTFail() }
        guard view.bounds.height != 0 else { return XCTFail() }
        switch mode {
        case .record: record(view, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
        case .test: test(view, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
        }
    }
    
}

extension PixelTestCase {
    
    // MARK: Private
    
    private func record(_ view: UIView, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) {
        let result = testCoordinator.record(view, layoutStyle: layoutStyle, scale: scale, testCase: self, function: function)
        switch result {
        case .success(let image):
            addAttachment(named: "Recorded image", image: image)
            XCTFail("Snapshot recorded (see recorded image in logs), disable record mode and re-run tests to verify.", file: file, line: line)
        case .fail(let errorMessage):
            XCTFail(errorMessage, file: file, line: line)
        }
    }
    
    private func test(_ view: UIView, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) {
        let result = testCoordinator.test(view, layoutStyle: layoutStyle, scale: scale, testCase: self, function: function)
        switch result {
        case .success(_):
            removeDiffAndFailureImages(function: function, scale: scale, layoutStyle: layoutStyle)
        case .fail(let failed):
            if let testImage = failed.test, let oracleImage = failed.oracle {
                storeDiffAndFailureImages(from: testImage, recordedImage: oracleImage, function: function, scale: scale, layoutStyle: layoutStyle)
            }
            XCTFail(failed.message)
        }
    }
    
    private func storeDiffAndFailureImages(from failedImage: UIImage, recordedImage: UIImage, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let diffImage = failedImage.diff(with: recordedImage), let url = fileCoordinator.fileURL(for: self, forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            addAttachment(named: "Diff image", image: diffImage)
            let data = UIImagePNGRepresentation(diffImage)
            try? data?.write(to: url, options: .atomic)
        }
        if let url = fileCoordinator.fileURL(for: self, forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            addAttachment(named: "Failed image", image: failedImage)
            addAttachment(named: "Original image", image: recordedImage)
            let data = UIImagePNGRepresentation(failedImage)
            try? data?.write(to: url, options: .atomic)
        }
    }
    
    private func addAttachment(named name: String, image: UIImage) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        add(attachment)
    }
    
    private func removeDiffAndFailureImages(function: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = fileCoordinator.fileURL(for: self, forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            try? FileManager.default.removeItem(at: url)
        }
        if let url = fileCoordinator.fileURL(for: self, forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
}
