// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "url_launcher_macos", path: "../.packages/url_launcher_macos"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation"),
        .package(name: "app_links", path: "../.packages/app_links"),
        .package(name: "firebase_crashlytics", path: "../.packages/firebase_crashlytics"),
        .package(name: "firebase_core", path: "../.packages/firebase_core")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "app-links", package: "app_links"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "firebase-core", package: "firebase_core")
            ]
        )
    ]
)
