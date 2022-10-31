import Foundation

public enum SystemProgram {
    // MARK: - Nested type

    public enum Index {
        static let create: UInt32 = 0
        static let transfer: UInt32 = 2
    }


    // MARK: - Instruction builders

    public static func transferInstruction(
        from fromPublicKey: PublicKey,
        to toPublicKey: PublicKey,
        lamports: UInt64
    ) -> TransactionInstruction {
        
        let keys = [
            SolanaAccount.Meta(publicKey: fromPublicKey, isSigner: true, isWritable: true),
            SolanaAccount.Meta(publicKey: toPublicKey, isSigner: false, isWritable: true),
        ]
        let programId = try! PublicKey(string: "11111111111111111111111111111111")
        let data: [BytesEncodable] = [Index.transfer, lamports]
        
        return TransactionInstruction(keys: keys, programId: programId, data: data)
    }
}

