//
//  Imageable.swift
//  PixelTest
//
//  Created by Przemeyslaw Wrzesinski on 15/02/2019.
//

import Foundation

public protocol Imageable {
    
    /// Creates an image from Imageable type.
    ///
    /// - Parameter scale: The scale of the image to create.
    /// - Returns: An image, or nil if an image couldn't be created.
    func image(withScale scale: Scale) -> UIImage?
    
}
