//
//  ExampleModuleView.swift
//  ExampleModule
//
//  Created by Kane Cheshire on 09/10/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import UIKit

final class ExampleModuleView: UIView {

	// MARK: - Properties -
	// MARK: Outlets

	// MARK: - Functions -
	// MARK: Overrides

	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}

	// MARK: Internal

	func configure(with viewModel: ExampleModuleViewModel) {
	}

	// MARK: Private

	private func setup() {
        backgroundColor = .red
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
	}

}

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(classForCoder())", bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T>() -> T {
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
}

