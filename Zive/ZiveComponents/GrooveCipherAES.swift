import Foundation
import CommonCrypto

enum GrooveCipherAESMode {
    case cbc
    case ecb

    var grooveCipherAESAlgorithmOptions: CCOptions {
        switch self {
        case .cbc:
            return CCOptions(0)
        case .ecb:
            return CCOptions(kCCOptionECBMode)
        }
    }
}

enum GrooveCipherAESPadding {
    case pkcs7
    case zeroPadding

    var grooveCipherAESAlgorithmOptions: CCOptions {
        switch self {
        case .pkcs7:
            return CCOptions(kCCOptionPKCS7Padding)
        case .zeroPadding:
            return CCOptions(0)
        }
    }
}

enum GrooveCipherAESEncoding {
    case base64
    case hex
}

enum GrooveCipherAESCharset {
    case utf8

    var grooveCipherAESStringEncoding: String.Encoding {
        switch self {
        case .utf8:
            return .utf8
        }
    }
}

enum GrooveCipherAESError: LocalizedError {
    case grooveCipherAESInvalidKeyLength
    case grooveCipherAESInvalidIvLength
    case grooveCipherAESInvalidTextEncoding
    case grooveCipherAESInvalidCipherEncoding
    case grooveCipherAESCryptoFailed(status: CCCryptorStatus)
    case grooveCipherAESResultEncodingFailed

    var errorDescription: String? {
        switch self {
        case .grooveCipherAESInvalidKeyLength:
            return "AES key must be 16, 24, or 32 bytes."
        case .grooveCipherAESInvalidIvLength:
            return "AES IV must be 16 bytes in CBC mode."
        case .grooveCipherAESInvalidTextEncoding:
            return "Unable to encode or decode the string with the selected charset."
        case .grooveCipherAESInvalidCipherEncoding:
            return "Unable to parse the cipher text with the selected input encoding."
        case let .grooveCipherAESCryptoFailed(status):
            return "AES operation failed with status \(status)."
        case .grooveCipherAESResultEncodingFailed:
            return "Unable to convert AES result into the requested format."
        }
    }
}

struct GrooveCipherAESConfiguration {
    let grooveCipherAESKey: String
    let grooveCipherAESIv: String?
    let grooveCipherAESMode: GrooveCipherAESMode
    let grooveCipherAESPadding: GrooveCipherAESPadding
    let grooveCipherAESCharset: GrooveCipherAESCharset
    let grooveCipherAESOutputEncoding: GrooveCipherAESEncoding

    init(
        grooveCipherAESKey: String,
        grooveCipherAESIv: String? = nil,
        grooveCipherAESMode: GrooveCipherAESMode = .cbc,
        grooveCipherAESPadding: GrooveCipherAESPadding = .pkcs7,
        grooveCipherAESCharset: GrooveCipherAESCharset = .utf8,
        grooveCipherAESOutputEncoding: GrooveCipherAESEncoding = .base64
    ) {
        self.grooveCipherAESKey = grooveCipherAESKey
        self.grooveCipherAESIv = grooveCipherAESIv
        self.grooveCipherAESMode = grooveCipherAESMode
        self.grooveCipherAESPadding = grooveCipherAESPadding
        self.grooveCipherAESCharset = grooveCipherAESCharset
        self.grooveCipherAESOutputEncoding = grooveCipherAESOutputEncoding
    }
}

private enum GrooveCipherAESDefaults {
    static let grooveCipherAESConfiguration = GrooveCipherAESConfiguration(
        grooveCipherAESKey: "66o3spbmw7t9q1p5",
        grooveCipherAESIv: "6y0zfx2kaofz4orj",
        grooveCipherAESMode: .cbc,
        grooveCipherAESPadding: .pkcs7,
        grooveCipherAESCharset: .utf8,
        grooveCipherAESOutputEncoding: .hex
    )
}

extension String {
    func grooveCipherAESEncrypt() -> String {
        (try? grooveCipherAESEncryptValue(
            using: GrooveCipherAESDefaults.grooveCipherAESConfiguration
        )) ?? ""
    }

    func grooveCipherAESDecrypt() -> String {
        (try? grooveCipherAESDecryptValue(
            using: GrooveCipherAESDefaults.grooveCipherAESConfiguration
        )) ?? ""
    }

    private func grooveCipherAESEncryptValue(
        using grooveCipherAESConfiguration: GrooveCipherAESConfiguration
    ) throws -> String {
        let grooveCipherAESPlainData = try grooveCipherAESData(
            using: grooveCipherAESConfiguration.grooveCipherAESCharset
        )
        let grooveCipherAESCipherData = try grooveCipherAESCrypt(
            operation: CCOperation(kCCEncrypt),
            grooveCipherAESInputData: grooveCipherAESPlainData,
            grooveCipherAESConfiguration: grooveCipherAESConfiguration
        )

        switch grooveCipherAESConfiguration.grooveCipherAESOutputEncoding {
        case .base64:
            return grooveCipherAESCipherData.base64EncodedString()
        case .hex:
            return grooveCipherAESCipherData.grooveCipherAESHexString
        }
    }

    private func grooveCipherAESDecryptValue(
        using grooveCipherAESConfiguration: GrooveCipherAESConfiguration
    ) throws -> String {
        let grooveCipherAESCipherData = try grooveCipherAESDecodeCipherData(
            using: grooveCipherAESConfiguration.grooveCipherAESOutputEncoding
        )
        let grooveCipherAESPlainData = try grooveCipherAESCrypt(
            operation: CCOperation(kCCDecrypt),
            grooveCipherAESInputData: grooveCipherAESCipherData,
            grooveCipherAESConfiguration: grooveCipherAESConfiguration
        )
        let grooveCipherAESNormalizedData = grooveCipherAESPlainData.grooveCipherAESRemovingTrailingZeros()

        guard let grooveCipherAESPlainText = String(
            data: grooveCipherAESNormalizedData,
            encoding: grooveCipherAESConfiguration.grooveCipherAESCharset.grooveCipherAESStringEncoding
        ) else {
            throw GrooveCipherAESError.grooveCipherAESResultEncodingFailed
        }

        return grooveCipherAESPlainText
    }

    private func grooveCipherAESData(
        using grooveCipherAESCharset: GrooveCipherAESCharset
    ) throws -> Data {
        guard let grooveCipherAESData = data(using: grooveCipherAESCharset.grooveCipherAESStringEncoding) else {
            throw GrooveCipherAESError.grooveCipherAESInvalidTextEncoding
        }

        return grooveCipherAESData
    }

    private func grooveCipherAESDecodeCipherData(
        using grooveCipherAESEncoding: GrooveCipherAESEncoding
    ) throws -> Data {
        switch grooveCipherAESEncoding {
        case .base64:
            guard let grooveCipherAESData = Data(base64Encoded: self) else {
                throw GrooveCipherAESError.grooveCipherAESInvalidCipherEncoding
            }
            return grooveCipherAESData
        case .hex:
            guard let grooveCipherAESData = Data(grooveCipherAESHexString: self) else {
                throw GrooveCipherAESError.grooveCipherAESInvalidCipherEncoding
            }
            return grooveCipherAESData
        }
    }

    private func grooveCipherAESCrypt(
        operation grooveCipherAESOperation: CCOperation,
        grooveCipherAESInputData: Data,
        grooveCipherAESConfiguration: GrooveCipherAESConfiguration
    ) throws -> Data {
        let grooveCipherAESKeyData = try grooveCipherAESConfiguration.grooveCipherAESKey.grooveCipherAESData(
            using: grooveCipherAESConfiguration.grooveCipherAESCharset
        )

        guard [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256].contains(grooveCipherAESKeyData.count) else {
            throw GrooveCipherAESError.grooveCipherAESInvalidKeyLength
        }

        let grooveCipherAESIvData: Data?
        switch grooveCipherAESConfiguration.grooveCipherAESMode {
        case .cbc:
            let grooveCipherAESIvString = grooveCipherAESConfiguration.grooveCipherAESIv ?? ""
            let grooveCipherAESIvValue = try grooveCipherAESIvString.grooveCipherAESData(
                using: grooveCipherAESConfiguration.grooveCipherAESCharset
            )
            guard grooveCipherAESIvValue.count == kCCBlockSizeAES128 else {
                throw GrooveCipherAESError.grooveCipherAESInvalidIvLength
            }
            grooveCipherAESIvData = grooveCipherAESIvValue
        case .ecb:
            grooveCipherAESIvData = nil
        }

        let grooveCipherAESOptions = grooveCipherAESConfiguration.grooveCipherAESMode.grooveCipherAESAlgorithmOptions
            | grooveCipherAESConfiguration.grooveCipherAESPadding.grooveCipherAESAlgorithmOptions

        let grooveCipherAESInputBytes: Data
        switch grooveCipherAESConfiguration.grooveCipherAESPadding {
        case .pkcs7:
            grooveCipherAESInputBytes = grooveCipherAESInputData
        case .zeroPadding:
            grooveCipherAESInputBytes = grooveCipherAESInputData.grooveCipherAESZeroPadded(
                blockSize: kCCBlockSizeAES128
            )
        }

        var grooveCipherAESOutputLength = 0
        var grooveCipherAESOutputData = Data(
            count: grooveCipherAESInputBytes.count + kCCBlockSizeAES128
        )
        let grooveCipherAESOutputBufferSize = grooveCipherAESOutputData.count

        let grooveCipherAESStatus = grooveCipherAESOutputData.withUnsafeMutableBytes { grooveCipherAESOutputBuffer in
            grooveCipherAESInputBytes.withUnsafeBytes { grooveCipherAESInputBuffer in
                grooveCipherAESKeyData.withUnsafeBytes { grooveCipherAESKeyBuffer in
                    if let grooveCipherAESIvData {
                        return grooveCipherAESIvData.withUnsafeBytes { grooveCipherAESIvBuffer in
                            CCCrypt(
                                grooveCipherAESOperation,
                                CCAlgorithm(kCCAlgorithmAES),
                                grooveCipherAESOptions,
                                grooveCipherAESKeyBuffer.baseAddress,
                                grooveCipherAESKeyData.count,
                                grooveCipherAESIvBuffer.baseAddress,
                                grooveCipherAESInputBuffer.baseAddress,
                                grooveCipherAESInputBytes.count,
                                grooveCipherAESOutputBuffer.baseAddress,
                                grooveCipherAESOutputBufferSize,
                                &grooveCipherAESOutputLength
                            )
                        }
                    } else {
                        return CCCrypt(
                            grooveCipherAESOperation,
                            CCAlgorithm(kCCAlgorithmAES),
                            grooveCipherAESOptions,
                            grooveCipherAESKeyBuffer.baseAddress,
                            grooveCipherAESKeyData.count,
                            nil,
                            grooveCipherAESInputBuffer.baseAddress,
                            grooveCipherAESInputBytes.count,
                            grooveCipherAESOutputBuffer.baseAddress,
                            grooveCipherAESOutputBufferSize,
                            &grooveCipherAESOutputLength
                        )
                    }
                }
            }
        }

        guard grooveCipherAESStatus == kCCSuccess else {
            throw GrooveCipherAESError.grooveCipherAESCryptoFailed(status: grooveCipherAESStatus)
        }

        grooveCipherAESOutputData.removeSubrange(grooveCipherAESOutputLength..<grooveCipherAESOutputData.count)
        return grooveCipherAESOutputData
    }
}

private extension Data {
    var grooveCipherAESHexString: String {
        map { String(format: "%02x", $0) }.joined()
    }

    func grooveCipherAESZeroPadded(blockSize: Int) -> Data {
        let grooveCipherAESRemainder = count % blockSize
        guard grooveCipherAESRemainder != 0 else { return self }

        var grooveCipherAESPaddedData = self
        grooveCipherAESPaddedData.append(contentsOf: Array(repeating: 0, count: blockSize - grooveCipherAESRemainder))
        return grooveCipherAESPaddedData
    }

    func grooveCipherAESRemovingTrailingZeros() -> Data {
        var grooveCipherAESBytes = [UInt8](self)
        while grooveCipherAESBytes.last == UInt8(0) {
            grooveCipherAESBytes.removeLast()
        }
        return Data(grooveCipherAESBytes)
    }

    init?(grooveCipherAESHexString: String) {
        let grooveCipherAESNormalizedHex = grooveCipherAESHexString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard grooveCipherAESNormalizedHex.count.isMultiple(of: 2) else { return nil }

        var grooveCipherAESData = Data(capacity: grooveCipherAESNormalizedHex.count / 2)
        var grooveCipherAESIndex = grooveCipherAESNormalizedHex.startIndex

        while grooveCipherAESIndex < grooveCipherAESNormalizedHex.endIndex {
            let grooveCipherAESNextIndex = grooveCipherAESNormalizedHex.index(grooveCipherAESIndex, offsetBy: 2)
            let grooveCipherAESByteString = grooveCipherAESNormalizedHex[grooveCipherAESIndex..<grooveCipherAESNextIndex]

            guard let grooveCipherAESByte = UInt8(grooveCipherAESByteString, radix: 16) else {
                return nil
            }

            grooveCipherAESData.append(grooveCipherAESByte)
            grooveCipherAESIndex = grooveCipherAESNextIndex
        }

        self = grooveCipherAESData
    }
}
