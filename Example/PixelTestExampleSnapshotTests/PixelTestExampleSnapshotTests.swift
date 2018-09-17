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
        let model = SimpleViewModel(title: "Hello World", subtitle: "This is a test")
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
    
    // By populating the view with super long data we can test how the layout works, without ever running the app.
    
    func test_simpleView_longData() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: "Aliquam ullamcorper gravida erat, ornare bibendum metus efficitur ac. Quisque sed felis ornare leo fermentum elementum. Suspendisse sagittis maximus erat vel bibendum.",
                                    subtitle: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at est quis orci porta cursus ut nec metus. Praesent lorem orci, elementum vel diam id, volutpat lacinia sem. Duis eget dictum ex, sit amet rutrum diam. Suspendisse potenti. Vestibulum quis neque malesuada ante malesuada tempus. Donec venenatis egestas sapien vel maximus. Suspendisse aliquet, est sed auctor pretium, ex urna iaculis magna, sit amet accumsan sem turpis et massa. Praesent augue elit, faucibus sit amet velit id, scelerisque fermentum nibh.
            
Ut vulputate venenatis ex non condimentum. Aliquam vulputate venenatis efficitur. Sed sit amet interdum metus. Praesent scelerisque magna vel magna tincidunt posuere. Etiam quis semper ligula. Donec id posuere nulla. Curabitur mattis nisi leo, eu ullamcorper tellus luctus vitae. Phasellus augue dolor, feugiat vel risus vel, mattis cursus leo. Suspendisse efficitur malesuada tortor vitae faucibus
""")
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
    
    // We can even go as far as testing how the view should look when data is missing
    
    func test_simpleView_emptySubtitle() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: "Hello World", subtitle: "")
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
    }
    
    // More advanced usage could even test multiple widths, useful for checking layouts gracefully handle common screen sizes
    
    func test_simpleView_longData_multipleWidths() {
        let view: SimpleView = .loadFromNib()
        let model = SimpleViewModel(title: "Aliquam ullamcorper gravida erat, ornare bibendum metus efficitur ac. Quisque sed felis ornare leo fermentum elementum. Suspendisse sagittis maximus erat vel bibendum.",
                                    subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at est quis orci porta cursus ut nec metus. Praesent lorem orci, elementum vel diam id, volutpat lacinia sem. Duis eget dictum ex, sit amet rutrum diam. Suspendisse potenti. Vestibulum quis neque malesuada ante malesuada tempus. Donec venenatis egestas sapien vel maximus. Suspendisse aliquet, est sed auctor pretium, ex urna iaculis magna, sit amet accumsan sem turpis et massa. Praesent augue elit, faucibus sit amet velit id, scelerisque fermentum nibh.")
        view.configure(with: model)
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 320))
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 375))
        verify(view, layoutStyle: .dynamicHeight(fixedWidth: 414))
    }
    
}
