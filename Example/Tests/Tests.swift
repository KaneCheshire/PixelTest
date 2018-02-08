import UIKit
import XCTest
import PixelTest

class Tests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
//        mode = .record
    }
    
    func test_regularSize() throws {
        try verifyView(with: CGSize(width: 100, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointZeroOne_width() throws {
        try verifyView(with: CGSize(width: 100.01, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointNineNine_width() throws {
        try verifyView(with: CGSize(width: 100.99, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointTwoFive_width() throws {
        try verifyView(with: CGSize(width: 100.25, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointSevenFive_width() throws {
        try verifyView(with: CGSize(width: 100.75, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointFive_width() throws {
        try verifyView(with: CGSize(width: 100.5, height: 100), file: #file, function: #function, line: #line)
    }
    
    func test_pointZeroOne_height() throws {
        try verifyView(with: CGSize(width: 100, height: 100.01), file: #file, function: #function, line: #line)
    }
    
    func test_pointNineNine_height() throws {
        try verifyView(with: CGSize(width: 100, height: 100.99), file: #file, function: #function, line: #line)
    }
    
    func test_pointFive_height() throws {
        try verifyView(with: CGSize(width: 100, height: 100.5), file: #file, function: #function, line: #line)
    }
    
    func test_pointTwoFive_height() throws {
        try verifyView(with: CGSize(width: 100, height: 100.25), file: #file, function: #function, line: #line)
    }
    
    func test_pointSevenFive_height() throws {
        try verifyView(with: CGSize(width: 100, height: 100.75), file: #file, function: #function, line: #line)
    }
    
}

extension Tests {
    
    private func verifyView(with size: CGSize, file: StaticString, function: StaticString, line: UInt) throws {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        view.backgroundColor = .red
        // Uncomment to make test fail
//        view.text = "Hello World"
        
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor), //TODO: Can all this fuff be handled by the test case?
            ])
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        try verify(view, file: file, function: function, line: line)
    }
    
}

