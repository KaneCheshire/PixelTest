//
//  TargetBaseDirectoryCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/04/2018.
//

import Foundation
import PathKit
import xcproj

/// Coordinates finding and manipulating the target's base directory.
struct TargetBaseDirectoryCoordinator: TargetBaseDirectoryCoordinatorType {
    
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
    
    /// Finds the target base directory for a test case's target.
    ///
    /// - Parameters:
    ///   - testCase: The test case to find the base directory for.
    ///   - pixelTestBaseDirectory: The root directory PixelTest uses (the project root usually).
    /// - Returns: A URL for the target's base directory, or nil if a URL couldn't be determined.
    func targetBaseDirectory(for testCase: PixelTestCase, pixelTestBaseDirectory: String) -> URL? {
        guard let enumerator = fileManager.enumerator(atPath: pixelTestBaseDirectory) else { return nil }
        for fileOrDir in enumerator.compactMap({ $0 as? String }) {
            guard fileOrDir.contains(".xcodeproj") else { continue }
            let projectPath = "\(pixelTestBaseDirectory)/\(fileOrDir)"
            guard let project = try? XcodeProj(pathString: projectPath) else { continue }
            let targetNames = project.pbxproj.objects.nativeTargets.map { $0.value.name }
            guard targetNames.contains(testCase.moduleName) else { continue }
            return URL(fileURLWithPath: projectPath).deletingLastPathComponent()
        }
        return nil
    }
    
}
