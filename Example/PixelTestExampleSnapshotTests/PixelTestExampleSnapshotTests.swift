//
//  PixelTestExampleSnapshotTests.swift
//  PixelTestExampleSnapshotTests
//
//  Created by Kane Cheshire on 20/03/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import XCTest
import PixelTest
@testable import PixelTest_Example

// Try changing values below to make tests fail. Failed tests include diff images in test reports (found in the last tab on the left sidebar in Xcode)

class PixelTestExampleSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        mode = .test // Change this to .record to record new snapshots or overwrite existing ones
    }
    
    // A good initial test is how the view should look with regular expected data
    
    func test_simpleView_regularData() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: .shortContent, subtitle: .shortContent, image: .small)
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
    // By populating the view with super long data we can test how the layout works, without ever running the app.
    
    func test_simpleView_longData() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: .longContent, subtitle: .longContent, image: .large)
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
    // We can even go as far as testing how the view should look when data is missing
    
    func test_simpleView_emptySubtitle() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: .shortContent, subtitle: .emptyContent, image: .large)
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight)
    }
    
    // More advanced usage could even test multiple widths, useful for checking layouts gracefully handle common screen sizes
    
    func test_simpleView_longData_multipleWidths() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: .longContent, subtitle: .longContent, image: .large)
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight)
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 375))
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 414))
    }
    
}
