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
    
    // MARK: - Properties -
    // MARK: Open
    
    /// The current mode of the test case. Set to `.record` when setting up or recording tests.
    /// If you have set a global override in the test target's Info.plist, this value is ignored.
    /// Defaults to `.test`.
    open var mode: Mode = .test
    
    // MARK: Public
    
    /// The name of the HTML file PixelTets auto-generates
    /// You might want to change this to something specific for your project or Fastlane setup, for example.
    public static var failureHTMLFilename: String = "pixeltest_failures"
    
    // MARK: Internal
    
    var layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator()
    var recordCoordinator: RecordCoordinatorType = RecordCoordinator()
    var testCoordinator: TestCoordinatorType = TestCoordinator()
    var fileCoordinator: FileCoordinatorType = FileCoordinator()
    
    // MARK: Private
    
    private let resultsCoordinator: ResultsCoordinator = .shared
    private lazy var testTargetInfoPlist = InfoPlist(bundle: Bundle(for: type(of: self)))
    private var actualMode: Mode {
        if ProcessInfo.recordAll || testTargetInfoPlist.recordAll {
            return .record
        }
        return mode
    }
    
    // MARK: - Functions -
    // MARK: Open
    
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
        XCTAssertTrue(view.bounds.width > 0, "View has no width after layout", file: file, line: line)
        XCTAssertTrue(view.bounds.height > 0, "View has no height after layout", file: file, line: line)
        let config = Config(function: function, file: file, line: line, scale: scale, layoutStyle: layoutStyle)
        switch actualMode {
            case .record: record(view, config: config)
            case .test: test(view, config: config)
        }
    }
    
}

private extension PixelTestCase {
    
    // MARK: Private
    
    func record(_ view: UIView, config: Config) {
        do {
            let image = try recordCoordinator.record(view, config: config)
            addAttachment(named: "Recorded image", image: image)
            XCTFail("Snapshot recorded (see attached image in logs), disable record mode and re-run tests to verify.", file: config.file, line: config.line)
        } catch let error as Errors.Record {
            XCTFail(error.localizedDescription, file: config.file, line: config.line)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test(_ view: UIView, config: Config) {
        do {
            try testCoordinator.test(view, config: config)
            fileCoordinator.removeDiffAndFailureImages(config: config) // TODO: Do this after recording
        } catch let error as Errors.Test {
            handle(error, config: config)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func handle(_ error: Errors.Test, config: Config) {
        switch error {
            case .imagesAreDifferent(let referenceImage, let failedImage):
                storeDiffAndFailureImages(from: failedImage, recordedImage: referenceImage, config: config)
            case .unableToCreateSnapshot, .unableToGetRecordedImage, .unableToGetRecordedImageData: break
        }
        XCTFail(error.localizedDescription, file: config.file, line: config.line)
    }
    
    func storeDiffAndFailureImages(from failedImage: UIImage, recordedImage: UIImage, config: Config) {
        addAttachment(named: "Failed image", image: failedImage)
        addAttachment(named: "Original image", image: recordedImage)
        if let diffImage = failedImage.diff(with: recordedImage) {
            fileCoordinator.store(diffImage: diffImage, failedImage: failedImage, config: config)
            addAttachment(named: "Diff image", image: diffImage)
        }
    }
    
}
