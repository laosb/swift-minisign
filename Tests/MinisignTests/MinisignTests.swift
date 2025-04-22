// SPDX-License-Identifier: MIT
// Based on https://github.com/slarew/swift-minisign
// Copyright 2021 Stephen Larew, 2025 Shibo Lyu

import Foundation
import Minisign
import Testing

struct MinisignTests {

  // password: test
  static let privKey = """
    untrusted comment: minisign encrypted secret key
    RWRTY0Iyvmea6pdrXYdDVqn91GknFBllkJmsQyS2jpVGoBqETB4AAAACAAAAAAAAAEAAAAAAr5jLDlb+ahHMPoPZAawLCKbUilW5ECEFsFCFSQLXfKrFQDv54sYqJzr3rR4gTmDnplQY+/T+EYCZkc5+QJOWwmaKBHPRx+Tw3rFH4CfCGkYRr4WNdZprmAzi1ZNzTl/wyvc1/uplgO8=

    """

  static let pubKey = """
    untrusted comment: minisign public key E28A983382D6D7E9
    RWTp19aCM5iK4plw14gbtviwUSISZP++TJMfOfNTKoCcRIkcrV13Oppe

    """

  static let signature = """
    untrusted comment: signature from minisign secret key
    RWTp19aCM5iK4olS02BlgllVHi3lvR9OYUVu7gM/lMsTRsO2Qb1IBxJBt3xW14hAFZo7Zlceavr7u69Rt0Wk5wMX0ShF13DZygY=
    trusted comment: timestamp:1629695994\tfile:test.pub
    o4E++I6KyX1h3iYMQ5yNyqEfhphdrIXiFmnWarzbB1BQpsckcO1I3LLttzS1w2CjCEauKZ3bOeY//sYui8rbAQ==

    """

  static let badSignature = """
    untrusted comment: signature from minisign secret key
    RWTp19aCM5iK4olS02BlgllVHi3lvR9OYUVu7gM/lMsTRsO2Qb1IBxJBt3xW14hAFZo7Zlceavr7u69Rt0Wk5wMX0ShF13DZygY=
    trusted comment: timestamp:1629695994\tfile:test.pu
    o4E++I6KyX1h3iYMQ5yNyqEfhphdrIXiFmnWarzbB1BQpsckcO1I3LLttzS1w2CjCEauKZ3bOeY//sYui8rbAQ==

    """

  static let prehashedSignature = """
    untrusted comment: signature from minisign secret key
    RUTp19aCM5iK4qzCz7Z/Y4YGsKxamuPediRB9WhvHRWnrJFREb/m9TCwxQUlug1QMYMqgaEi3IGS0trOxy4xhCkS3D7ksjLEFQg=
    trusted comment: timestamp:1629695918\tfile:test.pub
    0sZUtAIqxCkdV8nQ5+bODUIX09QZS4ilrsCT6wjkTXhsMJ2cQKL0wYH3Km8ZGG46Q2OhOY8sPl+2DTLjvrMmBg==

    """

  static let badPrehashedSignature = """
    untrusted comment: signature from minisign secret key
    RUTp19aCM5iK4qzCz7Z/Y4YGsKxamuPediRB9WhvHRWnrJFREb/m9TCwxQUlug1QMYMqgaEi3IGS0trOxy4xhCkS3D7ksjLEFQg=
    trusted comment: timestamp:1629695918\tfile:test.pu
    0sZUtAIqxCkdV8nQ5+bODUIX09QZS4ilrsCT6wjkTXhsMJ2cQKL0wYH3Km8ZGG46Q2OhOY8sPl+2DTLjvrMmBg==

    """

  @Test func parse() {
    let pubKey = PublicKey(text: Self.pubKey.data(using: .utf8)!)
    #expect(pubKey != nil)
    #expect(pubKey?.untrustedComment == "minisign public key E28A983382D6D7E9")
    #expect(pubKey?.keyID == Data(base64Encoded: "6dfWgjOYiuI=")!)
    #expect(pubKey?.signatureAlgorithm == .pureEdDSA)
    let sig = Signature(text: Self.signature.data(using: .utf8)!)
    #expect(sig != nil)
    #expect(sig?.untrustedComment == "signature from minisign secret key")
    #expect(sig?.trustedComment == "timestamp:1629695994\tfile:test.pub")
    #expect(sig?.signatureAlgorithm == .pureEdDSA)
    #expect(sig?.keyID == Data(base64Encoded: "6dfWgjOYiuI=")!)
  }

  @Test func signature() {
    let pubKey = PublicKey(text: Self.pubKey.data(using: .utf8)!)
    #expect(pubKey != nil)
    let sig = Signature(text: Self.signature.data(using: .utf8)!)
    #expect(sig != nil)

    #expect(pubKey!.isValidSignature(sig!, for: Self.pubKey.data(using: .utf8)!))
    #expect(!pubKey!.isValidSignature(sig!, for: Self.pubKey.data(using: .utf8)!.advanced(by: 1)))

    let badSig = Signature(text: Self.badSignature.data(using: .utf8)!)
    #expect(badSig != nil)
    #expect(!pubKey!.isValidSignature(badSig!, for: Self.pubKey.data(using: .utf8)!))
  }

  @Test func prehashedSignature() {
    let pubKey = PublicKey(text: Self.pubKey.data(using: .utf8)!)
    #expect(pubKey != nil)
    let phSig = Signature(text: Self.prehashedSignature.data(using: .utf8)!)
    #expect(phSig != nil)

    #expect(pubKey!.isValidSignature(phSig!, for: Self.pubKey.data(using: .utf8)!))
    #expect(!pubKey!.isValidSignature(phSig!, for: Self.pubKey.data(using: .utf8)!.advanced(by: 1)))

    let badPhSig = Signature(text: Self.badPrehashedSignature.data(using: .utf8)!)
    #expect(badPhSig != nil)
    #expect(!pubKey!.isValidSignature(badPhSig!, for: Self.pubKey.data(using: .utf8)!))
  }

  @Test func prehashedSignatureForFile() {
    let pubKey = PublicKey(text: Self.pubKey.data(using: .utf8)!)
    #expect(pubKey != nil)
    let phSig = Signature(text: Self.prehashedSignature.data(using: .utf8)!)
    #expect(phSig != nil)

    let fileURL = URL.temporaryDirectory.appending(component: "SwiftMinisignTests-\(UUID())-test.pub")
    defer { try? FileManager.default.removeItem(at: fileURL) }

    try! Self.pubKey.data(using: .utf8)!.write(to: fileURL)
    #expect(try! pubKey!.isValidSignature(phSig!, forFileAt: fileURL))
  }
}
