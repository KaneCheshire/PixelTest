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
    func record(_ view: UIView,
                layoutStyle: LayoutStyle,
                scale: Scale,
                function: StaticString,
                file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Record> {
        guard let image = view.image(withScale: scale) else {
            return .failure(.unableToCreateSnapshot)
        }
        guard let data = image.pngData() else {
            return .failure(.unableToCreateImageData)
        }
        do {
            let url = fileCoordinator.fileURL(for: function, file: file, scale: scale, imageType: .reference, layoutStyle: layoutStyle)
            try fileCoordinator.write(data, to: url)
            return .success(image)
        } catch {
            return .failure(.unableToWriteImageToDisk(error))
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
    func test(_ view: UIView,
              layoutStyle: LayoutStyle,
              scale: Scale,
              function: StaticString,
              file: StaticString) -> Result<UIImage, TestCoordinatorErrors.Test> { // TODO: Should this throw?
        guard let testImage = view.image(withScale: scale) else {
            return .failure(.unableToCreateSnapshot)
        }
        let url = fileCoordinator.fileURL(for: function, file: file, scale: scale, imageType: .reference, layoutStyle: layoutStyle)
        guard let data = try? fileCoordinator.data(at: url) else {
            return .failure(.unableToGetRecordedImageData)
        }
        guard let recordedImage = UIImage(data: data, scale: scale.explicitOrScreenNativeValue) else {
            return .failure(.unableToGetRecordedImage)
        }
        
        if !testImage.equalTo(recordedImage) {
            return .failure(.imagesAreDifferent(reference: recordedImage, failed: testImage))
        } else {
            return .success(testImage)
        }
    }
    
}
