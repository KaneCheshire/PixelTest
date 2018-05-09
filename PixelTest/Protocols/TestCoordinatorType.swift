//
//  TestCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 25/04/2018.
//

import Foundation

typealias ColorContrastFailureResult = (image: UIImage, message: String, textColor: UIColor, backgroundColor: UIColor)

protocol TestCoordinatorType {
    
    func record(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, testCase: PixelTestCase, function: StaticString) -> Result<UIImage, String>
    func test(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, testCase: PixelTestCase, function: StaticString) -> Result<UIImage, (oracle: UIImage?, test: UIImage?, message: String)>
    func verifyColorContrast(for view: UIView, standard: WCAGStandard, fallbackBackgoundColor: UIColor) -> [Result<Void, ColorContrastFailureResult>]
    
}
