import Foundation

final class ReceiveViewModel {
        
    private var account: SolanaAccount?
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func createNewAccount(completionHandler: @escaping (
        _ newAccount: Result<SolanaAccount, Error>
    ) -> Void ) {
        Task {
            do {
                self.account = try await SolanaAccount(phrase: [], network: .devnet)
                guard let acc = self.account else {
                    return
                }
                completionHandler(.success(acc))
            } catch let e {
                completionHandler(.failure(e))
            }
        }
    }
    
    func getBalance(completionHandler: @escaping (Result<Int, Error>) -> Void) throws {
        guard let publicKeyBase58 = account?.publicKey.base58EncodedString else {
            throw SolanaError.unknown
        }
        networkManager.getBalance(publicKeyBase58: publicKeyBase58, completionHandler: { result in
            switch result {
            case .success(let balance):
                completionHandler(.success(balance))
            case .failure(let error):
                // TODO: - Implement error handling
                print("error \(error)")
            }
        })
    }
}
