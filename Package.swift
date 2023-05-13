// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "ZZComposableInput",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "ZZComposableInput", targets: ["ZZComposableInput"]),
    ],
    targets: [
        .target(name: "ZZComposableInput", path: "Sources"),
    ]
)
