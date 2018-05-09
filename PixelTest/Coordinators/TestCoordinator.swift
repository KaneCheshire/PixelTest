//
//  TestCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import XCTest

/// Coordinates testing.
struct TestCoordinator: TestCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileCoordinator: FileCoordinatorType
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileCoordinator: FileCoordinatorType = FileCoordinator()) {
        self.fileCoordinator = fileCoordinator
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Records a snapshot of a view and writes it to disk.
    ///
    /// - Parameters:
    ///   - view: The view to record.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - testCase: The test case requesting the recording.
    ///   - function: The function called when requesting the recording.
    /// - Returns: A result with either an image for success or failure message.
    func record(_ view: UIView,
                layoutStyle: LayoutStyle,
                scale: Scale,
                testCase: PixelTestCase,
                function: StaticString) -> Result<UIImage, String> {
        guard let url = fileCoordinator.fileURL(for: testCase, forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle) else {
            return .fail("Unable to get URL")
        }
        guard let image = view.image(withScale: scale) else {
            return .fail("Unable to create snapshot")
        }
        guard let data = UIImagePNGRepresentation(image) else {
            return .fail("Unable to create image data")
        }
        do {
            try fileCoordinator.write(data, to: url)
            return .success(image)
        } catch {
            return .fail("Unable to write image data to disk")
        }
    }
    
    /// Tests a snapshot of a view, assuming a previously recorded snapshot exists for comparison.
    ///
    /// - Parameters:
    ///   - view: The view to test.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - testCase: The test case requesting the test.
    ///   - function: The function called when requesting the test.
    /// - Returns: A result with an image for success, or message with failed images for failure.
    func test(_ view: UIView,
              layoutStyle: LayoutStyle,
              scale: Scale,
              testCase: PixelTestCase,
              function: StaticString) -> Result<UIImage, (oracle: UIImage?, test: UIImage?, message: String)> {
        guard let url = fileCoordinator.fileURL(for: testCase, forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle) else {
            return .fail((nil, nil, "Unable to get URL"))
        }
        guard let testImage = view.image(withScale: scale) else {
            return .fail((nil, nil, "Unable to create snapshot"))
        }
        guard let data = try? fileCoordinator.data(at: url) else {
            return .fail((nil, nil, "Unable to get recorded image data"))
        }
        guard let recordedImage = UIImage(data: data, scale: scale.explicitOrScreenNativeValue) else {
            return .fail((nil, nil, "Unable to get recorded image"))
        }
        if !testImage.equalTo(recordedImage) {
            return .fail((recordedImage, testImage, "Snapshot test failed, images are different"))
        } else {
            return .success(testImage)
        }
    }
    
    // TODO: Partially transparent text colors?
    // TODO: Attributed strings?
    // TODO: Unit test
    
    /// Verifies that all visible labels have colors that comply with WCAG contrast ratios.
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - standard: The WCAG standard to use for verification.
    /// - Returns: Results with an image and message on failure.
    func verifyColorContrast(for view: UIView,
                             standard: WCAGStandard,
                             fallbackBackgoundColor: UIColor) -> [Result<Void, ColorContrastFailureResult>] {
        let allVisibleLabels = view.allLabels.filter { !$0.isHidden && $0.alpha > 0 }
        guard !allVisibleLabels.isEmpty else { fatalError("View does not contain visible labels") }
        let originalBackgroundColor = view.normalizedBackgroundColor(with: fallbackBackgoundColor)
        defer {
            view.backgroundColor = originalBackgroundColor
        }
        return allVisibleLabels.map { colorContrastResult(for: $0, in: view, with: standard) }
    }
    
}

private extension TestCoordinator {
    
    // MARK: Private
    
    private func colorContrastResult(for label: UILabel, in view: UIView, with standard: WCAGStandard) -> Result<Void, ColorContrastFailureResult> {
        let frame = label.convert(label.bounds, to: view)
        guard let imageWithLabel = view.image(of: frame, with: .native) else { fatalError("Unable to create image") }
        label.isHidden = true
        guard let imageWithoutLabel = view.image(of: frame, with: .native) else { fatalError("Unable to create image") }
        label.isHidden = false
        guard let backgroundAverageColor = imageWithoutLabel.averageColor() else { fatalError("Unable to determine average color")  }
        let ratio = label.textColor.wcagContrastRatio(comparedTo: backgroundAverageColor)
        let textSize = WCAGTextSize(for: label.font)
        let minimumRquiredRatio = standard.minContrastRatio(for: textSize)
        if ratio < minimumRquiredRatio {
            let message = failureMessage(withFailedRatio: ratio, textSize: textSize, standard: standard)
            return .fail((imageWithLabel, message, label.textColor, backgroundAverageColor))
        } else {
            return .success(())
        }
    }
    
    private func failureMessage(withFailedRatio failedRatio: CGFloat, textSize: WCAGTextSize, standard: WCAGStandard) -> String {
        let minimumRquiredRatio = standard.minContrastRatio(for: textSize)
        return "Color contrast ratio \(failedRatio):1 for \(textSize) text does not meet \(minimumRquiredRatio):1 for WCAG standard \(standard.displayText)"
    }
    
}
