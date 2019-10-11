//
//  TestCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 25/04/2018.
//

import Foundation

protocol TestCoordinatorType {
    
    func record(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, function: StaticString, file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Record>
    func test(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale, function: StaticString, file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Test>
    
}

enum TestCoordinatorErrors {
    
    enum Record: Error {
        case unableToCreateSnapshot
        case unableToCreateImageData
        case unableToWriteImageToDisk(Error)
    }
    
    enum Test: Error {
        case unableToCreateSnapshot
        case unableToGetRecordedImageData
        case unableToGetRecordedImage
        case imagesAreDifferent(reference: UIImage, failed: UIImage)
    }
    
}

extension TestCoordinatorErrors.Record {
    
    var errorMessage: String {
        switch self {
            case .unableToCreateImageData: return "Unable to create image data"
            case .unableToCreateSnapshot: return "Unable to create snapshot image"
            case .unableToWriteImageToDisk(let underlying): return "Unable to write image to disk: \(underlying.localizedDescription)"
        }
    }
    
}

extension TestCoordinatorErrors.Test {
    
    var errorMessage: String {
        switch self {
            case .unableToCreateSnapshot: return "Unable to create snapshot image"
            case .unableToGetRecordedImage: return "Unable to get recorded image"
            case .unableToGetRecordedImageData: return "Unable to get recorded image data"
            case .imagesAreDifferent: return "Images are different"
        }
    }
    
}
