# Swift Minisign

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaosb%2Fswift-minisign%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/laosb/swift-minisign)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaosb%2Fswift-minisign%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/laosb/swift-minisign)

Swift implementation of Minisign, a simple and secure tool for signing and verifying files.

This is a fork of [slarew/swift-minisign](https://github.com/slarew/swift-minisign), with these improvements:

- Convenient & efficient API for verifying (big) files
- `Sendable` conformance & full Swift 6 support
- Replaced C wrapping `swift-crypto-blake2` with [pure Swift implementation of blake2b](https://github.com/lovetodream/swift-blake2).
- For Apple platforms, Swift Crypto dependency is now optional, controllable via trait `UseSwiftCrypto`.

*but still, only signature verification is supported, signing not yet!*

## License

[MIT](LICENSE).
