# Changelog

# Pending

- Removed requirement for the `PIXELTEST_BASE_DIR` environment variable.
  - Snapshots are now stored in a directory relative to the test file, but this means a breaking change for existing PixelTest users.
- Removed dependency on xcproj, meaning PixelTest has no dependencies now!

# 1.2.0

- Xcode 10 and Swift 4.2 support

# 1.1.0

- PixelTest now auto-creates HTML files for failures.
- Fixes constraint warning when calling `verify()` repeatedly in the same test.
- Disables Bitcode at the podspec level.

# 1.0.0

- The `verify()` function no longer `throws`.
- Significantly better test coverage.

# 0.7.0

- Changes naming of `Option` to `LayoutStyle`.
- Adds the recorded snapshot as an `XCTAttachment`.

# 0.6.0

- Standardises filenames (which is a breaking change for people already using PixelTest).

# 0.5.0

- Adds support for adding `XCTAttachments` to test logs for failed tests.

# 0.4.0

- Uses the view's layer to render into images, removing the need for a key window.
- Fixes the test not showing which line failed properly.


# 0.3.0

- Fixed a bug setting the height as the value for width.
- Added support for multiple subprojects.

# 0.2.0

- Added cleanup functionality so diff/failure images are removed after a test succeeds.

# 0.1.0

- Initial release.
