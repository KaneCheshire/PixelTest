//
//  ResultsCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/07/2018.
//

import XCTest

final class ResultsCoordinator: NSObject {

    private var failures: [PixelTestCase] = []
    private let targetBaseCoordinator = TargetBaseDirectoryCoordinator()
    private let fileCoordinator = FileCoordinator()
    private let pixelTestBaseDir = ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"] ?? ""
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
    
}

extension ResultsCoordinator: XCTestObservation {
    
    func testBundleWillStart(_ testBundle: Bundle) {
        failures = []
    }
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        guard let testCase = testCase as? PixelTestCase, testCase.mode != .record else { return }
        let alreadyRecordedTestCase = failures.contains { $0.className == testCase.className }
        if !alreadyRecordedTestCase {
            failures.append(testCase)
        }
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) { // TODO: Clean up if no failures
        guard let firstTestCase = failures.first, let htmlDir = snapshotsDirectory(for: firstTestCase) else { return }
        let htmlStrings: [String] = failures.compactMap { generateHTMLString(for: $0) }
        let htmlBody = generateHTMLBodyString(withBody: htmlStrings.joined())
        try? fileCoordinator.write(Data(htmlBody.utf8), to: htmlDir.appendingPathComponent("\(PixelTestCase.failureHTMLFilename).html"))
    }
    
}

extension ResultsCoordinator {
    
    private func snapshotsDirectory(for testCase: PixelTestCase) -> URL? {
        guard let baseDir = targetBaseCoordinator.targetBaseDirectory(for: testCase, pixelTestBaseDirectory: pixelTestBaseDir) else { return nil }
        return baseDir.appendingPathComponent("\(testCase.moduleName)Snapshots")
    }
    
    private func generateHTMLString(for testCase: PixelTestCase) -> String? {
        guard let snapshotsDir = snapshotsDirectory(for: testCase) else { return nil }
        let diffDir = snapshotsDir.appendingPathComponent("Diff").appendingPathComponent(testCase.className).path
        let enumerator = FileManager.default.enumerator(atPath: diffDir)
        let diffURLs = enumerator?.compactMap { $0 as? String }.compactMap { URL(string: "\(diffDir)/\($0)") } ?? []
        return generateHTMLString(for: diffURLs)
    }
    
    private func generateHTMLString(for diffURLs: [URL]) -> String {
        return diffURLs.map { diffURL in
            let diffPath = diffURL.path
            let failurePath = diffPath.replacingOccurrences(of: "Diff", with: "Failure")
            let referencePath = diffPath.replacingOccurrences(of: "Diff", with: "Reference")
            let heading = diffURL.pathComponents.reversed()[..<2].reversed().joined(separator: "   ")
            return """
            <h2>\(heading)</h2>
            <p>
            <div>
            <div style='width: 33vw; display:inline-block;'>
                <img src=\(failurePath) width='100%' />
            </div>
            <div style='width: 33vw; display:inline-block;'>
                <img src=\(referencePath) width='100%' />
            </div>
            <div style='width: 33vw; display:inline-block;'>
                <img src=\(diffPath) width='100%' />
            </div>
            </p>
            <br />
            """
            }.joined()
//        return diffURLs.map { diffURL in
//            let diffPath = diffURL.path
//            let failurePath = diffPath.replacingOccurrences(of: "Diff", with: "Failure")
//            let referencePath = diffPath.replacingOccurrences(of: "Diff", with: "Reference")
//            let heading = diffURL.pathComponents.reversed()[..<2].reversed().joined(separator: "   ")
//            return """
//            <h2>\(heading)</h2>
//            <p>
//            <div onmousemove="mouseMoved(event, this)" class='split-container' style='width:auto;height:auto;position:relative;'>
//            <img src=\(failurePath) style='width:50vw' />
//                <div class='split-overlay' style='position:absolute; top:0; left:0; width: 50%; overflow:hidden; background:white; pointer-events:none;'>
//                <img src=\(referencePath) style='width:50vw' />
//                </div>
//                <div class='separator' style='position:absolute;left:50%;top:0; height:100%;width:1px;background:red;pointer-events:none;'></div>
//            </div>
//            </p>
//            <br />
//            """
//        }.joined()
    }
    
    private func generateHTMLBodyString(withBody body: String) -> String {
        return """
        <html>
            <head>
                <title>PixelTest failure report</title>
                <script>
                    function mouseMoved(e, element) {
                        e.offsetX, element.children[1].style["width"] = e.offsetX + "px"
                        e.offsetX, element.children[2].style["left"] = (e.offsetX + 1) + "px"
                    }
                </script>
                </head>
            <body style='background-color:#f1f1f1; margin:0; padding:0;'>
                \(body)
            </body>
        </html>
        """
    }
    
}
