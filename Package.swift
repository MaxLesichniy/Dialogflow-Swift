// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dialogflow",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "DialogflowModels",
                 targets: ["DialogflowModels"]),
        .library(name: "DialogflowModelsWebhook",
                 targets: ["DialogflowModels+Webhook"])
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "DialogflowModels",
                dependencies: ["AnyCodable"]),
//        .target(name: "DialogflowModels_WH",
//                dependencies: ["AnyCodable"],
//                path: "./Sources/DialogflowModels",
//                swiftSettings: [.define("WEBHOOK_MODELS")]),
        .target(name: "DialogflowModels+Webhook",
                dependencies: ["AnyCodable", "DialogflowModels"])
    ]
)
