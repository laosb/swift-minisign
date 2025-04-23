// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Minisign",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Minisign",
      targets: ["Minisign"]
    )
  ],
  traits: [
    .init(
      name: "UseSwiftCrypto",
      description:
        "Use Swift Crypto instead of Apple's CryptoKit. If targeting Apple platforms only, remove this trait to cut dependency on Swift Crypto."
    ),
    .default(enabledTraits: ["UseSwiftCrypto"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-crypto", from: "2.0.0"),
    .package(url: "https://github.com/lovetodream/swift-blake2", from: "0.1.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Minisign",
      dependencies: [
        .product(name: "Crypto", package: "swift-crypto", condition: .when(traits: ["UseSwiftCrypto"])),
        .product(name: "BLAKE2", package: "swift-blake2")
      ]
    ),
    .testTarget(
      name: "MinisignTests",
      dependencies: ["Minisign"]
    ),
  ]
)
