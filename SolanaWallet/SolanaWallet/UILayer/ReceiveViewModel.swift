import Foundation

final class ReceiveViewModel {
        
    private var account: SolanaAccount {
        userData.account
    }
    private var networkManager: NetworkManager
    private let userData: UserData
    
    init(networkManager: NetworkManager, state: UserData) {
        self.networkManager = networkManager
        self.userData = state
    }
    
    func createNewAccount(completionHandler: @escaping (
        _ newAccount: Result<SolanaAccount, Error>
    ) -> Void ) {
        Task {
            do {
                let newAccount = try await SolanaAccount(phrase: [], network: .devnet)
                userData.account = newAccount
                completionHandler(.success(newAccount))
            } catch let e {
                completionHandler(.failure(e))
            }
        }
    }
    
    func getBalance(completionHandler: @escaping (Result<Int, Error>) -> Void) throws {
        let publicKeyBase58 = account.publicKey.base58EncodedString
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
