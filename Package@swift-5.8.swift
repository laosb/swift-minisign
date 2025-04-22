// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Minisign",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .visionOS(.v1),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Minisign",
      targets: ["Minisign"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-crypto", from: "2.0.0"),
    .package(url: "https://github.com/lovetodream/swift-blake2", from: "0.1.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Minisign",
      dependencies: [
        .product(name: "Crypto", package: "swift-crypto"),
        .product(name: "BLAKE2", package: "swift-blake2"),
      ],
      swiftSettings: [
        .define("UseSwiftCrypto")
      ]
    ),
    .testTarget(
      name: "MinisignTests",
      dependencies: ["Minisign"]
    ),
  ],
  swiftLanguageModes: [.version("6"), .v5],
)
