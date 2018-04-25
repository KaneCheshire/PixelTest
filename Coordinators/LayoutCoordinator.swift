//
//  LayoutCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import Foundation

/// Coordinates laying out a view.
struct LayoutCoordinator: LayoutCoordinatorType {
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Lays out a view with a specified layout style.
    /// This handles embedding in a parent view and enforcing a layout pass.
    ///
    /// - Parameters:
    ///   - view: The view to lay out.
    ///   - layoutStyle: The style of layout.
    func layOut(_ view: UIView, with layoutStyle: LayoutStyle) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch layoutStyle {
        case .dynamicWidth(fixedHeight: let height):
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dynamicHeight(fixedWidth: let width):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        case .fixed(width: let width, height: let height):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dynamicWidthHeight: break
        }
        embed(view)
    }
    
    // MARK: Private
    
    private func embed(_ view: UIView) {
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
    }
    
}
