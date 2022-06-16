// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "static-site-generator",
    platforms: [
        .macOS("12.0")        
    ],
    products: [
        .executable(name: "static-site-generator", targets: ["static-site-generator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: Version(1, 1, 2))
    ],
    targets: [
        .executableTarget(
            name: "static-site-generator",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")                
            ]),
        .testTarget(
            name: "static-site-generator-tests",
            dependencies: ["static-site-generator"]),
    ]
)
