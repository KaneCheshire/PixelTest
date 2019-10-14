//
//  TestCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 25/04/2018.
//

import Foundation

protocol TestCoordinatorType {
    
    func record(_ view: UIView, config: Config) throws -> UIImage
    func test(_ view: UIView, config: Config) throws
    
}

enum TestCoordinatorErrors { // TODO: Move
    
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
            case .imagesAreDifferent: return "Images are different (see attached diff/failure images in logs)"
        }
    }
    
}
