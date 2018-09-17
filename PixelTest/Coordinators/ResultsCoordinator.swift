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
        removeExistingHTMLFiles()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
    
}

extension ResultsCoordinator: XCTestObservation {
    
    func testBundleWillStart(_ testBundle: Bundle) {
        failures = []
    }
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        guard let testCase = testCase as? PixelTestCase, testCase.mode != .record else { return }
        let alreadyStoredTestCase = failures.contains { $0.className == testCase.className }
        if !alreadyStoredTestCase {
            failures.append(testCase)
        }
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        guard let firstTestCase = failures.first, let htmlDir = snapshotsDirectory(for: firstTestCase) else { return }
        let headerHTML = "<h1 style='padding:32pt 32pt 0;'>Snapshot test failures for \(firstTestCase.moduleName)</h1>"
        let htmlStrings: [String] = failures.compactMap { generateHTMLString(for: $0) }
        let footerHTML = "<footer style='text-align:center; padding:0 32pt 32pt;'>PixelTest by Kane Cheshire</footer>"
        let htmlBody = generateHTMLBodyString(withBody: headerHTML + htmlStrings.joined() + footerHTML)
        do {
            print("Writing failure HTML file to URL:", htmlDir)
            try fileCoordinator.write(Data(htmlBody.utf8), to: htmlDir.appendingPathComponent("\(PixelTestCase.failureHTMLFilename).html"))
        } catch {
            print("Unable to create failure HTML file", error)
        }
    }
    
}

extension ResultsCoordinator {
    
    private func removeExistingHTMLFiles() {
        guard let enumerator = FileManager.default.enumerator(atPath: pixelTestBaseDir) else { return }
        let htmlFiles = enumerator.compactMap { $0 as? String }.filter { $0.contains("\(PixelTestCase.failureHTMLFilename).html") }.map { URL(fileURLWithPath: "\(pixelTestBaseDir)/\($0)") }
        htmlFiles.forEach { htmlFile in
            print("Removing HTML file at URL:", htmlFile)
            try? FileManager.default.removeItem(at: htmlFile)
        }
    }
    
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
            let heading = diffURL.pathComponents.reversed()[..<2].reversed().joined(separator: ": ")
            return """
            <section style='border-radius:5pt;background:rgba(245,245,245,0.9);margin:32pt 32pt;padding:0pt 16pt 0pt;'>
            <h2 style='padding:16pt 0;position:-webkit-sticky;background:rgba(245,245,245,0.9);top:0;-webkit-backdrop-filter: blur(2px); z-index:100;'>\(heading)</h2>
            <h3 style='width:33%;display:inline-block;margin:0 0 16pt;'>Failed</h3>
            <h3 style='width:33%;display:inline-block;margin:0 0 16pt;'>Original</h3>
            <h3 style='width:33%;display:inline-block;margin:0 0 16pt;'>Overlay split</h3>
            <div style='width:33%; display:inline-block;vertical-align:top;margin:0pt 0pt 16pt;'>
                <img src=\(failurePath) width='100%' />
            </div>
            <div style='width:33%; display:inline-block;vertical-align:top;margin:0pt 0pt 16pt;'>
                <img src=\(referencePath) width='100%' />
            </div>
            <div onmousemove="mouseMoved(event, this)" style='width:33%; display:inline-block; position:relative;vertical-align:top;margin:0pt 0pt 16pt;'><img src=\(referencePath) width='100%' /><div class='split-overlay' style='position:absolute; top:0; left:0; width: 50%; height:100%; overflow:hidden; pointer-events:none;'>
                    <img src=\(failurePath) style='width:calc(33vw - 32pt);max-height:100%;' />
                </div>
            <div class='separator' style='margin-left:-1pt;position:absolute;left:50%;top:0; height:100%;width:1pt;background:red;pointer-events:none;'></div>
            </section>
            """
            }.joined()
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
            <body style='background-color:white; margin:0; padding:0; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;'>
                \(body)
            </body>
        </html>
        """
    }
    
}
