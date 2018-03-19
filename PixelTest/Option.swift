//
//  Option.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

/// Represents an option for verifying a view.
///
/// - dynamicWidth: The view should have a dynamic width, but fixed height.
/// - dynamicHeight: The view should have a dynamic height, but fixed width.
/// - dynamicWidthHeight: The view should have a dynamic width and height.
/// - fixed: The view should have a fixed width and height.
public enum Option {
    case dynamicWidth(fixedHeight: CGFloat)
    case dynamicHeight(fixedWidth: CGFloat)
    case dynamicWidthHeight
    case fixed(width: CGFloat, height: CGFloat)
    
    var fileValue: String {
        switch self {
        case .dynamicWidth(fixedHeight: let height): return "dw_\(height)"
        case .dynamicHeight(fixedWidth: let width): return "\(width)_dh"
        case .dynamicWidthHeight: return "dw_dh"
        case .fixed(width: let width, height: let height): return "\(width)_\(height)"
        }
    }
}
