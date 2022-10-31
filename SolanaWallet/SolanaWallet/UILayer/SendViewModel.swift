import Foundation

final class SendViewModel {
    
    private let state: UserData
    private let blockchainClient: BlockchainClient
    
    init(client: BlockchainClient, state: UserData) {
        self.blockchainClient = client
        self.state = state
    }
    
    func sendMoney(destination: String, amount: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let account = state.account else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        let instruction = SystemProgram.transferInstruction(
            from: account.publicKey,
            to: try! PublicKey(string: destination),
            lamports: UInt64(amount)
        )
        
        blockchainClient.prepareTransaction(
            instructions: [instruction],
            signers: [account],
            feePayer: account.publicKey) { result in
                switch result {
                case .success:
                    completionHandler(.success(()))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
