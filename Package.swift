// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Smssme",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Smssme",
            targets: ["Smssme"]),
    ],
    dependencies: [
        // 외부 의존성
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Smssme"),
        .testTarget(
            name: "SmssmeTests",
            dependencies: ["Smssme"]),
    ]
)
