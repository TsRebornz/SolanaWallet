import Foundation
import TweetNacl

public struct SolanaAccount: Codable, Hashable {
    public let phrase: [String]
    public let publicKey: PublicKey
    public let secretKey: Data

    private init(phrase: [String], publicKey: PublicKey, secretKey: Data) {
        self.phrase = phrase
        self.publicKey = publicKey
        self.secretKey = secretKey
    }
    
//    public init(secretKey: Data) throws {
//        let keys = try NaclSign.KeyPair.keyPair(fromSecretKey: secretKey)
//        publicKey = try PublicKey(data: keys.publicKey)
//        self.secretKey = keys.secretKey
//        let phrase = try Mnemonic.toMnemonic(secretKey.bytes)
//        self.phrase = phrase
//    }

    /// Create account with seed phrase
    /// - Parameters:
    ///   - phrase: secret phrase for an account, leave it empty for new account
    ///   - network: network in which account should be created
    /// - Throws: Error if the derivation is not successful
    public init(phrase: [String] = [], network: NetworkModel) async throws {
        self = try await Task {
            let mnemonic: Mnemonic
            var phrase = phrase.filter { !$0.isEmpty }
            
            mnemonic = Mnemonic()
            phrase = mnemonic.phrase
            
            let derivablePath: DerivablePath
            if phrase.count == 12 {
                derivablePath = .init(type: .deprecated, walletIndex: 0, accountIndex: 0)
            } else {
                derivablePath = .default
            }

            let keys = try Ed25519HDKey.derivePath(derivablePath.rawValue, seed: mnemonic.seed.toHexString()).get()
            let keyPair = try NaclSign.KeyPair.keyPair(fromSeed: keys.key)
            let publicKey: PublicKey = try PublicKey(data: keyPair.publicKey)

            let secretKey = keyPair.secretKey

            return .init(phrase: phrase, publicKey: publicKey, secretKey: secretKey)
        }.value
    }
}

//public extension Account {
//    struct Meta: Equatable, Codable, CustomDebugStringConvertible {
//        public let publicKey: PublicKey
//        public var isSigner: Bool
//        public var isWritable: Bool
//
//        // MARK: - Decodable
//
//        enum CodingKeys: String, CodingKey {
//            case pubkey, signer, writable
//        }
//
//        public init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            publicKey = try PublicKey(string: try values.decode(String.self, forKey: .pubkey))
//            isSigner = try values.decode(Bool.self, forKey: .signer)
//            isWritable = try values.decode(Bool.self, forKey: .writable)
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(publicKey.base58EncodedString, forKey: .pubkey)
//            try container.encode(isSigner, forKey: .signer)
//            try container.encode(isWritable, forKey: .writable)
//        }
//
//        // Initializers
//        public init(publicKey: PublicKey, isSigner: Bool, isWritable: Bool) {
//            self.publicKey = publicKey
//            self.isSigner = isSigner
//            self.isWritable = isWritable
//        }
//
//        public static func readonly(publicKey: PublicKey, isSigner: Bool) -> Self {
//            .init(publicKey: publicKey, isSigner: isSigner, isWritable: false)
//        }
//
//        public static func writable(publicKey: PublicKey, isSigner: Bool) -> Self {
//            .init(publicKey: publicKey, isSigner: isSigner, isWritable: true)
//        }
//
//        public var debugDescription: String {
//            "{\"publicKey\": \"\(publicKey.base58EncodedString)\", \"isSigner\": \(isSigner), \"isWritable\": \(isWritable)}"
//        }
//    }
//}
//
