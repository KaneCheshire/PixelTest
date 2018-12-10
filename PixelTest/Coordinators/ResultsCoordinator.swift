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
        let footerHTML = "<footer style='text-align:center; padding:0 32pt 32pt;'>PixelTest by Kane Cheshire</footer>"
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
            let heading = diffURL.pathComponents.dropFirst(pixelTestComponentComponent + 1).joined(separator: " ").replacingOccurrences(of: "/\(ImageType.diff.rawValue)", with: "")
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
            <div class='separator' style='margin-left:-1pt;position:absolute;left:50%;top:0; height:100%;width:0.5pt;background:red;pointer-events:none;'></div>
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
                </head>
            <body style='background-color:white; margin:0; padding:0; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;'>
                \(body)
            </body>
        </html>
        """
    }
    
}
