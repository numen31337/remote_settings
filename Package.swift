// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteSettings",
    platforms: [
        .iOS(.v9),
        .watchOS(.v3),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "RemoteSettings",
            targets: ["RemoteSettings"]),
    ],
    targets: [
        .target(
            name: "RemoteSettings",
            dependencies: []),
        .testTarget(
            name: "RemoteSettingsTests",
            dependencies: ["RemoteSettings"]),
    ]
)
