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
    
    /// Creates a full file URL.
    /// Ensure PIXELTEST_BASE_DIR is set in your scheme before calling this function. // TODO: is this really needed?
    ///
    /// - Parameters:
    ///   - function: The function used to construct the file URL.
    ///   - scale: The scale used to to construct the file URL.
    ///   - imageType: The image type used to construct the file URL.
    ///   - layoutStyle: The layout style used to construct the file URL.
    /// - Returns: A full file URL, or nil if a URL could not be created.
    func fileURL(for function: StaticString,
                 file: StaticString,
                 filenameSuffix: String,
                 scale: Scale,
                 imageType: ImageType,
                 layoutStyle: LayoutStyle) -> URL {
        
        let fullFileURL = URL(fileURLWithPath: "\(file)")
        var alphaNumericFunctionName = "\(function)".strippingNonAlphaNumerics
        alphaNumericFunctionName.remove(firstOccurenceOf: "test_")
        alphaNumericFunctionName.remove(firstOccurenceOf: "test")
        let directoryName = fullFileURL.deletingPathExtension().lastPathComponent
        
        let url = fullFileURL
            .deletingLastPathComponent()
            .appendingPathComponent(".pixeltest")
            .appendingPathComponent(directoryName)
            .appendingPathComponent(alphaNumericFunctionName)
            .appendingPathComponent(imageType.rawValue)
        createDirectoryIfNecessary(url)
        
        return url.appendingPathComponent("\(layoutStyle.fileValue)@\(scale.explicitOrScreenNativeValue)x_\(filenameSuffix).png") // TODO: Use native name?
    }
    
    func imageExists(for function: StaticString,
                     file: StaticString,
                     filenameSuffix: String,
                     scale: Scale,
                     imageType: ImageType,
                     layoutStyle: LayoutStyle) -> Bool {
        
        let url = fileURL(for: function,
                          file: file,
                          filenameSuffix: filenameSuffix,
                          scale: scale,
                          imageType: imageType,
                          layoutStyle: layoutStyle)
        return fileManager.fileExists(atPath: url.relativePath)
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
    ///   - function: The function the images were created with.
    ///   - scale: The scale the images were created with.
    ///   - layoutStyle: The style of layout the images were created with.
    func storeDiffImage(_ diffImage: UIImage,
                        failedImage: UIImage,
                        function: StaticString,
                        file: StaticString,
                        filenameSuffix: String,
                        scale: Scale,
                        layoutStyle: LayoutStyle) {
        
        let diffUrl = fileURL(for: function,
                              file: file,
                              filenameSuffix: filenameSuffix,
                              scale: scale,
                              imageType: .diff,
                              layoutStyle: layoutStyle)
        
        if let diffData = diffImage.pngData() {
            try? write(diffData, to: diffUrl)
        }
        
        let url = fileURL(for: function,
                          file: file,
                          filenameSuffix: filenameSuffix,
                          scale: scale,
                          imageType: .failure,
                          layoutStyle: layoutStyle)
        
        if let failedData = failedImage.pngData() {
            try? write(failedData, to: url)
        }
    }
    
    /// Removes diff and failure images from disk (if they exist).
    ///
    /// - Parameters:
    ///   - function: The function the diff and failure images were originally for.
    ///   - scale: The scale the diff and failure images were originally created in.
    ///   - layoutStyle: The style of layout the images were created with.
    func removeDiffAndFailureImages(function: StaticString,
                                    file: StaticString,
                                    filenameSuffix: String,
                                    scale: Scale,
                                    layoutStyle: LayoutStyle) {
        
        let diffURL = fileURL(for: function,
                              file: file,
                              filenameSuffix: filenameSuffix,
                              scale: scale,
                              imageType: .diff,
                              layoutStyle: layoutStyle)
        
        try? fileManager.removeItem(at: diffURL)
        
        let failureUrl = fileURL(for: function,
                                 file: file,
                                 filenameSuffix: filenameSuffix,
                                 scale: scale,
                                 imageType: .failure,
                                 layoutStyle: layoutStyle)
        
        try? fileManager.removeItem(at: failureUrl)
    }
    
    /// Attempts to find the common path from a set of URLs.
    /// For example, the common path between these urls:
    ///
    /// `/a/b/c`
    /// `/a/b/c/d`
    /// `/a/b`
    ///
    /// Would return `"/a/b"`
    func commonPath(from urls: Set<URL>) -> String? {
        let allUniqueComponents = urls.map { $0.pathComponents }
        guard var smallestComponentsCount = allUniqueComponents.min(by: { $0.count < $1.count })?.count else { return nil }
        var unique = Set(allUniqueComponents.map { $0[..<smallestComponentsCount] })
        while unique.count > 1 {
            smallestComponentsCount -= 1
            unique = Set(unique.map { $0[..<smallestComponentsCount] })
        }
        guard var components = unique.first, let url = URL(string: components.removeFirst()) else { return nil }
        return components.reduce(into: url, { $0.appendPathComponent($1) }).path
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
