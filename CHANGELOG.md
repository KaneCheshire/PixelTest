# Changelog

## 2.2.0

- Added conveniences for calling `verify` with a `UIViewController`, `UITableViewCell` or `UICollectionViewCell` directly without having to pass in the `view` or `contentView` manually.
- Added convenience `.dynamicHeight` `LayoutStyle` you can use in your tests which automatically resolves to `.dynamicHeight(fixedWidth: 320)` since that's the most common: `verify(view, layoutStyle: .dynamicHeight)`
- Added a way to override the `mode` globally, either per-Xcode scheme (which re-records every test in every test target), or per-test target (which re-records every test in the target). 
    - In the Xcode scheme you add an environment variable called `PTRecordAll` with a value of `YES`.
    - In the individual test targets you add a new `Boolean` entry into its `Info.plist` called `PTRecordAll` with a value of `YES`.
- Added a way to generate placeholder images of any size using `UIImage.sized(width: 250, height: 100)`. Images are generated in code and aren't stored as assets, so PixelTest will be able to support Swift Package Manager still in the future.
- Tests will now automatically fail if you forget to add at least one call to  `verify` in your test function.
- Small improvements to the failure message when a test fails because the images are different.
- Fixed a rogue apostrophe in the generated failure HTML code which caused the layout to break a bit.
- Hides and shows the red split indicator on the generated failure HTML when you hover over the overlaid split images (so that it doesn't obscure the content)/
- Added a conventional "checkerboard" background to transparent images in the generate failure HTML.
- Generated failue HTML file now indicates how many failures there are in the tab title.



## 2.1.0

- Added public extension on String for generating short/medium/long content when populating view models for snapshots. See README for me information.

## 2.0.0

- Removed requirement for the `PIXELTEST_BASE_DIR` environment variable.
  - Snapshots are now stored in a directory relative to the test file, but this means a breaking change for existing PixelTest users.
- Removed dependency on xcproj, meaning PixelTest has no dependencies now!

## 1.2.0

- Xcode 10 and Swift 4.2 support

## 1.1.0

- PixelTest now auto-creates HTML files for failures.
- Fixes constraint warning when calling `verify()` repeatedly in the same test.
- Disables Bitcode at the podspec level.

## 1.0.0

- The `verify()` function no longer `throws`.
- Significantly better test coverage.

## 0.7.0

- Changes naming of `Option` to `LayoutStyle`.
- Adds the recorded snapshot as an `XCTAttachment`.

## 0.6.0

- Standardises filenames (which is a breaking change for people already using PixelTest).

## 0.5.0

- Adds support for adding `XCTAttachments` to test logs for failed tests.

## 0.4.0

- Uses the view's layer to render into images, removing the need for a key window.
- Fixes the test not showing which line failed properly.


## 0.3.0

- Fixed a bug setting the height as the value for width.
- Added support for multiple subprojects.

## 0.2.0

- Added cleanup functionality so diff/failure images are removed after a test succeeds.

## 0.1.0

- Initial release.
