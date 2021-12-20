// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let pixelTest: Product = .library(name: "PixelTest", targets: ["PixelTest"])
let target: Target = .target(name: pixelTest.name, path: "PixelTest")
let testTarget: Target = .testTarget(name: "Tests", dependencies: [.target(name: "PixelTest")], path: "Example/Tests")

let package = Package(name: pixelTest.name,
                      platforms: [.iOS(.v10)],
                      products: [pixelTest],
                      targets: [target, testTarget])
