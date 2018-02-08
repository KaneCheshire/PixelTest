import UIKit
import XCTest
import PixelTest

class ExampleTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
//        mode = .record
    }
    
    func test_regularSize() throws {
        try verifyView(with: .fixed(width: 100, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointZeroOne_width() throws {
        try verifyView(with: .fixed(width: 100.01, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointNineNine_width() throws {
        try verifyView(with: .fixed(width: 100.99, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointTwoFive_width() throws {
        try verifyView(with: .fixed(width: 100.25, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointSevenFive_width() throws {
        try verifyView(with: .fixed(width: 100.75, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointFive_width() throws {
        try verifyView(with: .fixed(width: 100.5, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointZeroOne_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.01), file: #file, function: #function, line: #line)
    }
    
    func test_pointNineNine_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.99), file: #file, function: #function, line: #line)
    }
    
    func test_pointFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.5), file: #file, function: #function, line: #line)
    }
    
    func test_pointTwoFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.25), file: #file, function: #function, line: #line)
    }
    
    func test_pointSevenFive_height() throws {
        try verifyView(with: .fixed(width: 100, height: 100.75), file: #file, function: #function, line: #line)
    }
    
    // TODO: Tests for other options, file writing etc.
    
}

extension ExampleTests {
    
    private func verifyView(with option: PixelTestCase.Option, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws {
        let view = UILabel()
        view.backgroundColor = .red
        try verify(view, option: option, file: file, function: function, line: line)
    }
    
}

