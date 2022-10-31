import Foundation

public struct TransactionInstruction: Codable {
    public let keys: [SolanaAccount.Meta]
    public let programId: PublicKey
    public let data: [UInt8]

    public init(keys: [SolanaAccount.Meta], programId: PublicKey, data: [BytesEncodable]) {
        self.keys = keys
        self.programId = programId
        self.data = data.bytes
    }

    enum CodingKeys: String, CodingKey {
        case keys, programId, data
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keys, forKey: .keys)
        try container.encode(programId.base58EncodedString, forKey: .programId)
        try container.encode(data.toHexString(), forKey: .data)
    }
}
