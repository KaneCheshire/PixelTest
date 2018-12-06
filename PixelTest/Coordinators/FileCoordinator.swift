//
//  PixelTestFileCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import Foundation

/// Coordinates manipulating files.
struct FileCoordinator: FileCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileManager: FileManagerType
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileManager: FileManagerType = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Attempts to create a full file URL.
    /// Ensure PIXELTEST_BASE_DIR is set in your scheme before calling this function.
    ///
    /// - Parameters:
    ///   - testCase: The test case used to construct the file URL.
    ///   - function: The function used to construct the file URL.
    ///   - scale: The scale used to to construct the file URL.
    ///   - imageType: The image type used to construct the file URL.
    ///   - layoutStyle: The layout style used to construct the file URL.
    /// - Returns: A full file URL, or nil if a URL could not be created.
    func fileURL(for function: StaticString,
                 file: StaticString,
                 scale: Scale,
                 imageType: ImageType,
                 layoutStyle: LayoutStyle) -> URL? { // TODO: No need for optional
        var alphaNumericFunctionName = "\(function)".strippingNonAlphaNumerics
        alphaNumericFunctionName.remove(firstOccurenceOf: "test_")
        alphaNumericFunctionName.remove(firstOccurenceOf: "test")
        let url = URL(fileURLWithPath: "\(file)")
            .deletingLastPathComponent()
            .appendingPathComponent(".pixeltest")
            .appendingPathComponent("snapshots")
            .appendingPathComponent(alphaNumericFunctionName)
            .appendingPathComponent(imageType.rawValue)
        createDirectoryIfNecessary(url)
        return url.appendingPathComponent("\(layoutStyle.fileValue)@\(scale.explicitOrScreenNativeValue)x.png") // TODO: Use native name?
    }
    
    /// Writes data to a file URL.
    ///
    /// - Parameters:
    ///   - data: The data to write.
    ///   - url: The file URL to write to.
    func write(_ data: Data, to url: URL) throws {
         try data.write(to: url, options: .atomic)
    }
    
    /// Reads the data at a file URL.
    ///
    /// - Parameter url: The file URL to read data from.
    /// - Returns: The data at the given URL.
    func data(at url: URL) throws -> Data {
        return try Data(contentsOf: url, options: .uncached)
    }
    
    /// Stores diff and failure images on-disk.
    ///
    /// - Parameters:
    ///   - diffImage: The diff image to store.
    ///   - failedImage: The failed image to store.
    ///   - pixelTestCase: The test case requesting the store.
    ///   - function: The function the images were created with.
    ///   - scale: The scale the images were created with.
    ///   - layoutStyle: The style of layout the images were created with.
    func storeDiffImage(_ diffImage: UIImage, failedImage: UIImage, function: StaticString, file: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = fileURL(for: function, file: file, scale: scale, imageType: .diff, layoutStyle: layoutStyle), let data = diffImage.pngData() {
            try? write(data, to: url)
        }
        if let url = fileURL(for: function, file: file, scale: scale, imageType: .failure, layoutStyle: layoutStyle), let data = failedImage.pngData() {
            try? write(data, to: url)
        }
    }
    
    /// Removes diff and failure images from disk (if they exist).
    ///
    /// - Parameters:
    ///   - pixelTestCase: The test case requesting the removal. // TODO: Update docs
    ///   - function: The function the diff and failure images were originally for.
    ///   - scale: The scale the diff and failure images were originally created in.
    ///   - layoutStyle: The style of layout the images were created with.
    func removeDiffAndFailureImages(function: StaticString, file: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = fileURL(for: function, file: file, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            try? fileManager.removeItem(at: url)
        }
        if let url = fileURL(for: function, file: file, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            try? fileManager.removeItem(at: url)
        }
    }
    
    // MARK: Private
    
    private func createDirectoryIfNecessary(_ url: URL) {
        guard !fileManager.fileExists(atPath: url.absoluteString) else { return }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil) // TODO: Catch error somewhere?
    }
    
}

private extension String {
    
    var strippingNonAlphaNumerics: String {
        return replacingOccurrences(of: "\\W+", with: "", options: .regularExpression)
    }
    
    mutating func remove(firstOccurenceOf string: String) {
        guard let range = range(of: string) else { return }
        return removeSubrange(range)
    }
    
}
