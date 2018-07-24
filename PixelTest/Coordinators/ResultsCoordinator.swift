//
//  ResultsCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/07/2018.
//

import XCTest

final class ResultsCoordinator: NSObject {
    
    private typealias FailureDict = [String: [FailureInfo]]
    
    private var failures: FailureDict = [:]
    private let targetBaseCoordinator = TargetBaseDirectoryCoordinator()
    private let fileCoordinator = FileCoordinator()
    private let pixelTestBaseDir = ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"] ?? ""
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
    
}

extension ResultsCoordinator: XCTestObservation {
    
    struct FailureInfo {
        let testCase: PixelTestCase
        let description: String
        let filePath: String?
        let line: Int
    }

    
    func testBundleWillStart(_ testBundle: Bundle) {
        failures = [:]
    }
    
    func testCaseWillStart(_ testCase: XCTestCase) {
        
    }
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        guard let testCase = testCase as? PixelTestCase else { return }
        let failureInfo = FailureInfo(testCase: testCase, description: description, filePath: filePath, line: lineNumber)
        var failureInfos = failures[testCase.className] ?? []
        failureInfos.append(failureInfo)
        failures[testCase.className] = failureInfos
    }
    
    func testCaseDidFinish(_ testCase: XCTestCase) {
        
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        failures.forEach { failureDict in
            guard let testCase = failureDict.value.first?.testCase else { return }
            guard let baseDirectory = targetBaseCoordinator.targetBaseDirectory(for: testCase, pixelTestBaseDirectory: pixelTestBaseDir) else { return }
            let snapshotsDirectory = baseDirectory.appendingPathComponent("\(testCase.moduleName)Snapshots")
            let diffDirectory = snapshotsDirectory.appendingPathComponent("Diff").appendingPathComponent(testCase.className).path
            guard let enumerator = FileManager.default.enumerator(atPath: diffDirectory) else { return }
            let diffURLs = enumerator.compactMap({ $0 as? String }).compactMap({  URL(string: "\(diffDirectory)/\($0)") })
            let htmlString = generateHTMLString(for: diffURLs)
            guard let data = htmlString.data(using: .utf8) else { return }
            let htmlFileURL = snapshotsDirectory.appendingPathComponent("results.html")
            try! fileCoordinator.write(data, to: htmlFileURL)
        }
    }
    
}

extension ResultsCoordinator {
    
    private func generateHTMLString(for diffImages: [URL]) -> String {
        let imagesHTML: [String] = diffImages.map { diffURL in
            let diffPath = diffURL.path
            let failurePath = diffPath.replacingOccurrences(of: "Diff", with: "Failure")
            let referencePath = diffPath.replacingOccurrences(of: "Diff", with: "Reference")
            let heading = diffURL.pathComponents.reversed()[..<2].reversed().reduce("", +)
            return """
            <h2>\(heading)</h2>
            <p>
            <div style='width:320pt;height:auto;'>
            </div>
            <img src=\(failurePath) width=320 />
            <img src=\(referencePath) width=320 />
            </p>
            <br />
            """
        }
        return """
        <html>
            <head>
                <title>PixelTest failure report</title>
            </head>
            <body>
                \(imagesHTML.reduce("", +))
            </body>
        </html>
        """
    }
    
}

private extension PixelTestCase {
    
    var memoryAddress: UnsafePointer<PixelTestCase> {
        var mutableSelf = self
        return withUnsafePointer(to: &mutableSelf) { $0 }
    }
    
}
