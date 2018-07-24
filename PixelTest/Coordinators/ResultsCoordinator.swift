//
//  ResultsCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/07/2018.
//

import XCTest

final class ResultsCoordinator: NSObject {
    
    private var failures: [String: [FailureInfo]] = [:]
    private let targetBaseCoordinator = TargetBaseDirectoryCoordinator()
    private let fileCoordinator = FileCoordinator()
    
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
        var failureInfos = failures[filePath ?? ""] ?? []
        failureInfos.append(failureInfo)
        failures[filePath ?? ""] = failureInfos
    }
    
    func testCaseDidFinish(_ testCase: XCTestCase) {
        
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        failures.forEach { failure in
            guard let testCase = failure.value.first?.testCase else { return }
            let baseDir = targetBaseCoordinator.targetBaseDirectory(for: testCase, pixelTestBaseDirectory: ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"] ?? "")!
            let snapshotsDir = baseDir.appendingPathComponent("\(testCase.moduleName)Snapshots")
            let diffDir = snapshotsDir.appendingPathComponent("Diff").appendingPathComponent(testCase.className).path
            guard let enumerator = FileManager.default.enumerator(atPath: diffDir) else { return }
            var diffURLs: [URL] = []
            for fileOrDir in enumerator.compactMap({ $0 as? String }) {
                let diffPath = "\(diffDir)/\(fileOrDir)"
                diffURLs += [URL(string: diffPath)!]
            }
            let fileURL = snapshotsDir.appendingPathComponent("results.html")
            let htmlString = self.htmlString(for: diffURLs)
            let data = htmlString.data(using: .utf8)!
            try! fileCoordinator.write(data, to: fileURL)
        }
        
        
    }
    
}

private extension ResultsCoordinator {
    
    func htmlString(for diffImages: [URL]) -> String {
        let images: [String] = diffImages.map { diffURL in
            let diffPath = diffURL.path
            let failurePath = diffPath.replacingOccurrences(of: "Diff", with: "Failure")
            let referencePath = diffPath.replacingOccurrences(of: "Diff", with: "Reference")
            return """
            <p>
                <img src=\(diffPath) width=320 />
                <img src=\(failurePath) width=320 />
                <img src=\(referencePath) width=320 />
            </p>
            <br />
            """
        }
        let reduced = images.reduce("", +)
        return """
        <html>
            <head>
                <title>PixelTest failure report</title>
            </head>
            <body>
                \(reduced)
            </body>
        </html>
        """
    }
    
}
