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
    
    // MARK: Public
    
    /// The name of the HTML file PixelTest auto-generates
    /// You might want to change this to something specific for your project or Fastlane setup, for example.
    public static var failureHTMLFilename: String = "pixeltest_failures"
    
    // MARK: Internal
    
    var layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator()
    
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
    open func verify(_ view: UIView,
                     layoutStyle: LayoutStyle,
                     scale: Scale = .native,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) {
        
        layoutCoordinator.layOut(view, with: layoutStyle)
        XCTAssertTrue(view.bounds.width > 0, "View has no width after layout", file: file, line: line)
        XCTAssertTrue(view.bounds.height > 0, "View has no height after layout", file: file, line: line)
        
        let result = PixelTest.verify(view, layoutStyle: layoutStyle, scale: scale, mode: mode)
        
        if let original = result.original {
            addAttachment(named: "Original image", image: original)
        }
        
        if let current = result.current {
            addAttachment(named: "Current image", image: current)
        }
        
        if let diff = result.diff {
            addAttachment(named: "Diff image", image: diff)
        }
    }
    
}
