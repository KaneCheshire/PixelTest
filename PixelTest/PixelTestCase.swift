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
    /// Defaults to `.test`.
    open var mode: Mode = .test
    
    // MARK: - Functions -
    // MARK: Open
    
    /// Verifies a view.
    ///
    /// If this is called while in record mode, a new snapshot are recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot, unless the reference image doesn't exist, in which case a reference image is recorded and saved.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - layoutStyle: The layout style to verify the view with.
    ///   - scale: The scale to record/test the snapshot with.
    open func verify(_ view: UIView,
                     layoutStyle: LayoutStyle,
                     scale: Scale = .native,
                     filenameSuffix: String = "",
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) {
        
        self.verify(view,
                    layoutStyle: layoutStyle,
                    scale: scale,
                    mode: mode,
                    filenameSuffix: filenameSuffix,
                    file: file,
                    function: function,
                    line: line)
    }
    
    /// Verifies an application by taking a screenshot.
    ///
    /// If this is called while in record mode, a new snapshot is recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot, unless the original image doesn't exist, in which case an original image is recorded and saved.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// - Parameters:
    ///   - app: The application to verify.
    ///   - clipFromTop: Height to clip from top. This is used to remove the status bar, which has dynamic elements such as the clock.
    open func verify(_ app: XCUIApplication,
                     clipFromTop: Int = 22,
                     filenameSuffix: String = "",
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) {
        
        self.verify(app,
                    clipFromTop: clipFromTop,
                    mode: mode,
                    filenameSuffix: filenameSuffix,
                    file: file,
                    function: function,
                    line: line)
    }
    
}
