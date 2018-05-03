//
//  TestCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 25/04/2018.
//

import Foundation

protocol TestCoordinatorType {
    
    func record(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, testCase: PixelTestCase, function: StaticString) -> Result<UIImage, String>
    func test(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, testCase: PixelTestCase, function: StaticString) -> Result<UIImage, (oracle: UIImage?, test: UIImage?, message: String)>
    func verifyColourContrast(for view: UIView, standard: WCAGStandard) -> [Result<Void, (image: UIImage, message: String)>]
    
}
