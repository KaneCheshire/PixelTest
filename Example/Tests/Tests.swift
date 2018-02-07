import UIKit
import XCTest
import PixelTest

class Tests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
//        mode = .record
    }
    
    func test_aView() throws {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        view.widthAnchor.constraint(equalToConstant: 500).isActive = true
        view.backgroundColor  = .red
        
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            ])
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        try verify(view)
    }
}

