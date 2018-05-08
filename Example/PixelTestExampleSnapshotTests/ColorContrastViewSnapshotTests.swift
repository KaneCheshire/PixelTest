//
//  ColorContrastViewSnapshotTests.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 02/05/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
import PixelTest
@testable import PixelTest_Example

class ColorContrastViewSnapshotTests: PixelTestCase {
    
    // PixelTest has built-in support for verifying that all visible labels in a view meet WCAG contrast guidelines.
    
    func test_colorContrast() {
        let view: ColorContrastView = .loadFromNib()
        verifyColorContrast(for: view, layoutStyle: .dynamicHeight(fixedWidth: 600), standard: .aaa)
    }
    
}
