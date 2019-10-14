//
//  TestCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import XCTest

/// Coordinates testing.
struct TestCoordinator: TestCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileCoordinator: FileCoordinatorType
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileCoordinator: FileCoordinatorType = FileCoordinator()) {
        self.fileCoordinator = fileCoordinator
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Records a snapshot of a view and writes it to disk.
    ///
    /// - Parameters:
    ///   - view: The view to record.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - function: The function called when requesting the recording.
    /// - Returns: A result with either an image for success or failure message.
    func record(_ view: UIView, config: Config) throws -> UIImage {
        guard let image = view.image(withScale: config.scale) else {
            throw TestCoordinatorErrors.Record.unableToCreateSnapshot
        }
        guard let data = image.pngData() else {
            throw TestCoordinatorErrors.Record.unableToCreateImageData
        }
        do {
            let url = fileCoordinator.fileURL(for: config, imageType: .reference)
            try fileCoordinator.write(data, to: url)
            return image
        } catch {
            throw TestCoordinatorErrors.Record.unableToWriteImageToDisk(error)
        }
    }
    
    /// Tests a snapshot of a view, assuming a previously recorded snapshot exists for comparison.
    ///
    /// - Parameters:
    ///   - view: The view to test.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - function: The function called when requesting the test.
    /// - Returns: A result with an image for success, or message with failed images for failure.
    func test(_ view: UIView, config: Config) throws {
        guard let testImage = view.image(withScale: config.scale) else {
            throw TestCoordinatorErrors.Test.unableToCreateSnapshot
        }
        let referenceURL = fileCoordinator.fileURL(for: config, imageType: .reference)
        guard let data = try? fileCoordinator.data(at: referenceURL) else {
            throw TestCoordinatorErrors.Test.unableToGetRecordedImageData
        }
        guard let recordedImage = UIImage(data: data, scale: config.scale.explicitOrScreenNativeValue) else {
            throw TestCoordinatorErrors.Test.unableToGetRecordedImage
        }
        guard testImage.equalTo(recordedImage) else {
            throw TestCoordinatorErrors.Test.imagesAreDifferent(reference: recordedImage, failed: testImage)
        }
    }
    
}
