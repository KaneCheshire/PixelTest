//
//  ResultsCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/07/2018.
//

import XCTest

/// Coordinates handling results and turning them into something useful, like a web page.
final class ResultsCoordinator: NSObject {

    // MARK: - Properties -
    // MARK: Internal
    
    static let shared = ResultsCoordinator()
    
    // MARK: Private
    
    private var failingFiles: Set<String> = []
    private let fileCoordinator = FileCoordinator()
    
    // MARK: - Init -
    // MARK: Overrides
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
    
}

extension ResultsCoordinator: XCTestObservation {
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        guard let filePath = filePath, let testCase = testCase as? PixelTestCase, testCase.mode != .record else { return }
        failingFiles.insert(filePath)
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        guard !failingFiles.isEmpty else { return }
        let failedURLs = Set(failingFiles.map { URL(fileURLWithPath: $0).deletingLastPathComponent() })
        guard let commonPath = fileCoordinator.commonPath(from: failedURLs) else { return }
        let htmlDir = URL(fileURLWithPath: commonPath)
        let footerHTML = "<footer><a href='https://github.com/KaneCheshire/PixelTest' target='_blank'>PixelTest</a> by <a href='https://twitter.com/kanecheshire' target='_blank'>Kane Cheshire</a></footer>"
        let allHTML = generateHTMLFileString(withBody: htmlStrings(forFailedURLs: failedURLs, htmlDir: htmlDir).joined() + footerHTML)
        try? fileCoordinator.write(Data(allHTML.utf8), to: htmlDir.appendingPathComponent("\(PixelTestCase.failureHTMLFilename).html"))
        failingFiles.removeAll()
    }
    
}

extension ResultsCoordinator {
    
    private func htmlStrings(forFailedURLs failedURLs: Set<URL>, htmlDir: URL) -> [String] {
        return failedURLs.compactMap { fileURL in
            let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
            let diffURLs: [URL] = enumerator!.compactMap { thing in
                guard let path = thing as? String else { return nil }
                let url = fileURL.appendingPathComponent(path)
                guard url.pathComponents.contains("Diff"), url.pathExtension == "png" else { return nil }
                return url
            }
            return generateHTMLString(for: diffURLs, htmlDir: htmlDir)
        }
    }
    
    private func generateHTMLString(for diffURLs: [URL], htmlDir: URL) -> String {
        return diffURLs.map { diffURL in
            let diffPath = diffURL.path
            let failurePath = diffPath.replacingOccurrences(of: ImageType.diff.rawValue, with: ImageType.failure.rawValue)
            let referencePath = diffPath.replacingOccurrences(of: ImageType.diff.rawValue, with: ImageType.reference.rawValue)
            let pixelTestComponentComponent = diffURL.pathComponents.firstIndex(where: { $0 == ".pixeltest" })!
            let heading = diffURL.pathComponents.dropFirst(pixelTestComponentComponent + 1).joined(separator: "/").replacingOccurrences(of: "/\(ImageType.diff.rawValue)", with: "")
            return """
            <section>
            <h2>\(heading)</h2>
            <h3>Failed</h3>
            <h3'>Original</h3>
            <h3>Overlay split</h3>
            <div class='snapshot-container'>
                <img src=\(failurePath) width='100%' />
            </div>
            <div class='snapshot-container'>
                <img src=\(referencePath) width='100%' />
            </div>
            <div class='snapshot-container' onmousemove="mouseMoved(event, this)">
                <img src=\(referencePath) width='100%' />
                <div class='split-overlay'>
                    <img src=\(failurePath) />
                </div>
            <div class='separator'></div>
            </section>
            """
            }.joined()
    }
    
    private func generateHTMLFileString(withBody body: String) -> String {
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
                <style>
                    a {
                        color: grey;
                    }
                    section {
                        border-radius: 5pt;
                        background: rgba(245,245,245,0.9);
                        margin: 32pt;
                        padding: 0pt 16pt 0pt;
                    }
                    h2 {
                        padding: 16pt 0;
                        position: -webkit-sticky;
                        background: rgba(245,245,245,0.9);
                        top: 0;
                        -webkit-backdrop-filter: blur(2px);
                        z-index: 100;
                    }
                    .snapshot-container {
                        width: 33%;
                        display: inline-block;
                        vertical-align: top;
                        margin: 0pt 0pt 16pt;
                        position:relative;
                    }
                    h3 {
                        width: 33%;
                        display: inline-block;
                        margin: 0 0 16pt;
                    }
                    .split-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 50%;
                        height: 100%;
                        overflow: hidden;
                        pointer-events: none;
                    }
                    .split-overlay > img {
                        width: calc(33vw - 32pt);
                        max-height: 100%;
                    }
                    .separator {
                        margin-left: -1pt;
                        position: absolute;
                        left: 50%;
                        top: 0;
                        height: 100%;
                        width: 0.1pt;
                        background: red;
                        pointer-events: none;
                    }
                    footer {
                        color: grey;
                        text-align: center;
                        padding: 0 32pt 32pt;
                    }
                </style>
            </head>
            <body style='background-color:white; margin:0; padding:0; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;'>
                \(body)
            </body>
        </html>
        """
    }
    
}
