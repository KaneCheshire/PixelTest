//
//  XCTestCase+PixelTest.swift
//  PixelTest
//
//  Created by Przemek Wrzesinski on 12/03/2019.
//

import XCTest

/// Runs visual tests in your test cases.
public extension XCTestCase {
    
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
    ///   - mode: Record the reference image or test against an existing one.
    public func verify(_ view: UIView,
                       layoutStyle: LayoutStyle,
                       scale: Scale = .native,
                       mode: Mode,
                       filenameSuffix: String = "",
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
        
        let result = PixelTest.verify(view, layoutStyle: layoutStyle, scale: scale, mode: mode, filenameSuffix: filenameSuffix)
        
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
    ///   - mode: Record the reference image or test against an existing one.
    public func verify(_ app: XCUIApplication,
                       clipFromTop: Int = 22,
                       mode: Mode,
                       filenameSuffix: String = "",
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
        
        guard let screenshot = app.screenshot().image.clip(fromTop: clipFromTop) else {
            print("PixelTest: Could not capture screenshot")
            return
        }
        
        let result = PixelTest.verify(screenshot, layoutStyle: .dynamicWidthHeight, mode: mode, filenameSuffix: filenameSuffix)
        
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
