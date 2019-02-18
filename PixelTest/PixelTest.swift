//
//  PixelTest.swift
//  PixelTest
//
//  Created by Przemek Wrzesinski on 15/02/2019.
//

import XCTest

/// Enables custom ways of visual application testing.
///
/// Use this class if you need custom testing functionality not covered by other classes.
/// Use it only from tests.
/// Remember to add `import PixelTest` at the beginning.
open class PixelTest {
    
    // MARK: - Properties -
    // MARK: Open
    
    // MARK: Public
    
    /// The name of the HTML file PixelTest auto-generates
    /// You might want to change this to something specific for your project or Fastlane setup, for example.
    public static var failureHTMLFilename: String = "pixeltest_failures"
    
    // MARK: Internal
    
    static let layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator()
    static let testCoordinator: TestCoordinatorType = TestCoordinator()
    static let fileCoordinator: FileCoordinatorType = FileCoordinator()
    
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
    public static func verify(_ imageable: Imageable,
                              layoutStyle: LayoutStyle,
                              scale: Scale = .native,
                              mode: Mode = .test,
                              file: StaticString = #file,
                              function: StaticString = #function,
                              line: UInt = #line) {
        
        if let view = imageable as? UIView {
            layoutCoordinator.layOut(view, with: layoutStyle)
        }
        switch mode {
        case .record:
            record(imageable, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
        case .test:
            if fileCoordinator.imageExists(for: function, file: file, scale: scale, imageType: .reference, layoutStyle: layoutStyle) {
                test(imageable, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
            } else {
                record(imageable, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
            }
        }
    }
    
}

extension PixelTest {
    
    // MARK: Private
    
    private static func record(_ imageable: Imageable, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) {
        let result = testCoordinator.record(imageable, layoutStyle: layoutStyle, scale: scale, function: function, file: file)
        switch result {
        case .success(_):
            XCTFail("Snapshot recorded (see attached image in logs), disable record mode and re-run tests to verify.", file: file, line: line)
        case .fail(let errorMessage):
            XCTFail(errorMessage, file: file, line: line)
        }
    }
    
    private static func test(_ imageable: Imageable, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) {
        let result = testCoordinator.test(imageable, layoutStyle: layoutStyle, scale: scale, function: function, file: file)
        switch result {
        case .success:
            fileCoordinator.removeDiffAndFailureImages(function: function, file: file, scale: scale, layoutStyle: layoutStyle)
        case .fail(let failed):
            if let testImage = failed.test, let oracleImage = failed.oracle {
                storeDiffAndFailureImages(from: testImage, recordedImage: oracleImage, function: function, file: file, scale: scale, layoutStyle: layoutStyle)
            }
            XCTFail(failed.message, file: file, line: line)
        }
    }
    
    private static func storeDiffAndFailureImages(from failedImage: UIImage, recordedImage: UIImage, function: StaticString, file: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        guard let diffImage = failedImage.diff(with: recordedImage) else { return }
        fileCoordinator.storeDiffImage(diffImage, failedImage: failedImage, function: function, file: file, scale: scale, layoutStyle: layoutStyle)
    }
}
