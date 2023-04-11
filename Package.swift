// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YStepper",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "YStepper",
            targets: ["YStepper"]
        )
    ],
    dependencies: [
        // For UI layout support, contrast ratio calculations.
        .package(url: "https://github.com/yml-org/YCoreUI.git", from: "1.7.0"),
        // For Typography support
        .package(url: "https://github.com/yml-org/YMatterType.git", from: "1.6.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "YStepper",
            dependencies: ["YCoreUI", "YMatterType"]
        ),
        .testTarget(
            name: "YStepperTests",
            dependencies: ["YStepper"]
        )
    ]
)
