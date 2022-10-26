import Foundation

final class ReceiveViewModel {
        
    func createNewAccount(completionHandler: @escaping (_ newAccount: Result<SolanaAccount, Error>) -> Void ) {
        Task {
            do {
                let account = try await SolanaAccount(phrase: [], network: .devnet)
                completionHandler(.success(account))
            } catch let e {
                completionHandler(.failure(e))
            }
        }
    }
}
