# PixelTest

[![CI Status](http://img.shields.io/travis/kanecheshire/PixelTest.svg?style=flat)](https://travis-ci.org/kanecheshire/PixelTest)
[![Version](https://img.shields.io/cocoapods/v/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)
[![License](https://img.shields.io/cocoapods/l/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)
[![Platform](https://img.shields.io/cocoapods/p/PixelTest.svg?style=flat)](http://cocoapods.org/pods/PixelTest)

PixelTest is a modern, Swift-only snapshot testing tool.

Snapshot testing compares one of your views rendered into an image, to a previously recorded image, allowing for 0% difference or the test will fail.

Snapshot tests are perfect for quickly checking complex layouts, while at the same time future proofing them against accidental changes.

Unlike other snapshot testing options, PixelTest supports declaring which resolution to record your snapshots in, so it doesn't matter which simulator you run your snapshot tests on.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

PixelTest currently only works in iOS projects.

## Author

@kanecheshire, kane.codes

## License

PixelTest is available under the MIT license. See the LICENSE file for more info.
