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
    
    // MARK: - Embedded types
    
    public struct PixelTestResult {
        let original: UIImage?
        let current: UIImage?
        let diff: UIImage?
    }
    
    // MARK: - Properties -
    // MARK: Internal
    
    fileprivate static let layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator()
    fileprivate static let testCoordinator: TestCoordinatorType = TestCoordinator()
    fileprivate static let fileCoordinator: FileCoordinatorType = FileCoordinator()
    
    // MARK: - Initializers -
    
    /// This class is not supposed to be initialized.
    private init() { }
    
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
                              filenameSuffix: String = "",
                              file: StaticString = #file,
                              function: StaticString = #function,
                              line: UInt = #line) -> PixelTestResult {
        
        if let view = imageable as? UIView {
            layoutCoordinator.layOut(view, with: layoutStyle)
        }
        switch mode {
        case .record:
            return record(imageable,
                          scale: scale,
                          filenameSuffix: filenameSuffix,
                          file: file, 
                          function: function,
                          line: line,
                          layoutStyle: layoutStyle)
        case .test:
            if fileCoordinator.imageExists(for: function,
                                           file: file,
                                           filenameSuffix: filenameSuffix,
                                           scale: scale,
                                           imageType: .reference,
                                           layoutStyle: layoutStyle) {
                return test(imageable,
                            scale: scale,
                            filenameSuffix: filenameSuffix,
                            file: file,
                            function: function,
                            line: line,
                            layoutStyle: layoutStyle)
            } else {
                return record(imageable,
                              scale: scale,
                              filenameSuffix: filenameSuffix,
                              file: file,
                              function: function,
                              line: line,
                              layoutStyle: layoutStyle)
            }
        }
    }
    
}

extension PixelTest {
    
    // MARK: Private
    
    private static func record(_ imageable: Imageable,
                               scale: Scale,
                               filenameSuffix: String,
                               file: StaticString,
                               function: StaticString,
                               line: UInt,
                               layoutStyle: LayoutStyle) -> PixelTestResult {
        
        let result = testCoordinator.record(imageable,
                                            layoutStyle: layoutStyle,
                                            scale: scale,
                                            filenameSuffix: filenameSuffix,
                                            function: function,
                                            file: file)
        switch result {
        case .success(let image):
            XCTFail("Snapshot recorded (see attached image in logs), disable record mode and re-run tests to verify.", file: file, line: line)
            return PixelTestResult(original: image, current: nil, diff: nil)
        case .fail(let errorMessage):
            XCTFail(errorMessage, file: file, line: line)
            return PixelTestResult(original: nil, current: nil, diff: nil)
        }
    }
    
    private static func test(_ imageable: Imageable,
                             scale: Scale,
                             filenameSuffix: String,
                             file: StaticString,
                             function: StaticString,
                             line: UInt,
                             layoutStyle: LayoutStyle) -> PixelTestResult {
        
        let result = testCoordinator.test(imageable,
                                          layoutStyle: layoutStyle,
                                          scale: scale,
                                          filenameSuffix: filenameSuffix,
                                          function: function,
                                          file: file)
        
        switch result {
        case .success(let image):
            fileCoordinator.removeDiffAndFailureImages(function: function,
                                                       file: file,
                                                       filenameSuffix: filenameSuffix,
                                                       scale: scale,
                                                       layoutStyle: layoutStyle)
            return PixelTestResult(original: nil, current: image, diff: nil)
            
        case .fail(let failed):
            if let testImage = failed.test, let oracleImage = failed.oracle {
                storeDiffAndFailureImages(from: testImage,
                                          recordedImage: oracleImage,
                                          function: function,
                                          file: file,
                                          filenameSuffix: filenameSuffix,
                                          scale: scale,
                                          layoutStyle: layoutStyle)
            }
            XCTFail(failed.message, file: file, line: line)
            return PixelTestResult(original: failed.oracle,
                                   current: failed.test,
                                   diff: failed.oracle.flatMap { failed.test?.diff(with: $0) } )
        }
    }
    
    private static func storeDiffAndFailureImages(from failedImage: UIImage,
                                                  recordedImage: UIImage,
                                                  function: StaticString,
                                                  file: StaticString,
                                                  filenameSuffix: String,
                                                  scale: Scale,
                                                  layoutStyle: LayoutStyle) {
        
        guard let diffImage = failedImage.diff(with: recordedImage) else { return }
        fileCoordinator.storeDiffImage(diffImage,
                                       failedImage: failedImage,
                                       function: function,
                                       file: file,
                                       filenameSuffix: filenameSuffix,
                                       scale: scale,
                                       layoutStyle: layoutStyle)
    }
}
