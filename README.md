# PixelTest

[![CI Status](http://img.shields.io/travis/KaneCheshire/PixelTest.svg?style=flat)](https://travis-ci.org/KaneCheshire/PixelTest)
[![Version](https://img.shields.io/cocoapods/v/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)
[![License](https://img.shields.io/cocoapods/l/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)
[![Platform](https://img.shields.io/cocoapods/p/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)

- [Key features](#key-features)
- [Why snapshot test](#why-snapshot-test)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Options](#options)
- [Accessibility](#accessibility)
- [Known limitations](#known-limitations)

PixelTest is a modern, Swift-first snapshot testing tool.

Snapshot testing compares one of your views rendered into an image, to a previously recorded image, allowing for 0% difference or the test will fail.

Snapshot tests are perfect for quickly checking complex layouts, while at the same time future proofing them against accidental changes.

As an added bonus, PixelTest also clears up after itself. If you fix a failing test, the failure and diff images are automatically removed for you.

## Key features

PixelTest is an excellent alternative to other options because PixelTest:

- Is written in Swift so it's able to take advantage of modern Swift features, like powerful enums.
- Handles laying out your views for you, leaving your project free of ugly layout code.
- Supports multiple subprojects/modules in your workspace, finding the right directory to store snapshots automatically.
- Helps you by showing you the diff image of failed tests directly in the test logs, with no need to leave Xcode.
- If tests fail, PixelTest automatically creates HTML files with interactive split overlays to see what went wrong.
- Automatically cleans up after itself by removing failed/diff images stored on disk when the corresponding test is fixed and passes.
- Works out of the box with no need to set up environment variables.
- Has no depdenencies.


## Why snapshot test?

Snapshot tests are an excellent (and super fast) way to ensure that your layout never breaks.

Logic is covered with unit tests, behaviour with automation/UI tests, and snapshot tests cover how the app actually looks. It ensures that complex layouts aren't broken from the start, which means less time going back and forth running the app, but also means you or anyone else is free to refactor a view without fear of breaking the way it looks.

## Installation

PixelTest is available on Cocoapods.

Add PixelTest to a **test target** in your `Podfile`:

```ruby
target 'YourAppTarget' do
  target 'YourAppTestTarget' do
    pod 'PixelTest'
  end
end
```

Then navigate to where your `Podfile` is located in Terminal and run `pod update`.

## Quick start

### Step 1

To begin, you'll want to create a unit test case **(not a UI test case, this is important!)**, and then subclass `PixelTestCase`:

```swift
import PixelTest
@testable import YourAppTarget

class TestClass: PixelTestCase {

}
```

### Step 2

Start writing some tests! Check out the example project for some simple examples. Once you've written your tests, you'll need to first record some reference images. To record images, override `setUp()` and set `mode` to `.record`:

```swift
class TestClass: PixelTestCase {

  override func setUp() {
    super.setUp()
    mode = .record
  }

  func test_someViewLaysOutProperly() {
    let view = MyCustomView()
    verify(view, layoutStyle: .dynamicHeight(fixedWidth: 100))
  }

}
```

Once you've overridden `setUp()`, simply run your tests. Each test that runs while `mode` is set to `.record` will record a reference image. Once you disable record mode (either by removing the line of code or by setting `mode` to `.test`), each subsequent run of your tests will check the saved reference image. If even 1 pixel is different, the test will fail.

If a test fails, you'll find two images in the `Diff` and `Failure` directories found in the `.pixeltest` directory automatically created in the same directory as your test file.

You can use these images to see what's changed and what went wrong. If it was an intentional change, you can re-record your snapshots. Be mindful to only run the tests you want to re-record in record mode, because it will overwrite any tests that run.

## Options

You can decide whether PixelTest tests your view with dynamic height or width, or fixed height and width. When you call `verify(view, ...)` you're also required to pass in an `LayoutStyle`. Typically this would be `.dynamicHeight(fixedWidth: 320)`, which means that PixelTest will attempt to test your view with a fixed with of `320`, but allow it to dynamically resize in height based on its content.

This leaves you free to populate your view without having ugly layout code in your project or modules.

## Accessibility

You can use PixelTest to test different Dynamic Type sizes if you set up your fonts and views in the right way. The example project has some examples on how to do this in `DynamicTypeViewSnapshotTests.swift`

## Known limitations

The way UIKit works with reusable views like `UITableViewCell`s and `UITableViewHeaderFooterView`s means that sometimes PixelTest needs to be used in a slightly different way.

The PixelTest example app has examples for how to do it, but with cells specifically you'll need to snapshot test the **`contentView`**, not the cell itself.

## Requirements

PixelTest currently [only works in iOS projects](https://github.com/KaneCheshire/PixelTest/issues/13).

## Author

@KaneCheshire, [kane.codes](http://kanecheshire.com)

## License

PixelTest is available under the MIT license. See the LICENSE file for more info.

The original idea for snapshot testing was FBSnapshotTest which was deprecated and later inherited by Uber. PixelTest is a much Swiftier alternative, with more features, less code to write and easier to follow open-source code.
