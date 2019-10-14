//
//  RecordCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 14/10/2019.
//

import Foundation

/// Coordinates recording.
struct RecordCoordinator: RecordCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileCoordinator: FileCoordinatorType
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileCoordinator: FileCoordinatorType = FileCoordinator()) {
        self.fileCoordinator = fileCoordinator
    }
    
    // MARK: Internal
    
    /// Records a snapshot of a view and writes it to disk.
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
    
}
