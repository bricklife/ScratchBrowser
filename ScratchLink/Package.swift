// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScratchLink",
    products: [
        .library(
            name: "ScratchLink",
            targets: ["ScratchLink"]),
    ],
    dependencies: [
        .package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-WebSockets.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "ScratchLink",
            dependencies: ["PerfectHTTPServer", "PerfectWebSockets"],
            exclude: [
                "scratch-link/macOS/Package.swift",
                "scratch-link/macOS/Sources/scratch-link/main.swift",
                "scratch-link/macOS/Sources/scratch-link/BTSession.swift",
            ])
    ]
)
