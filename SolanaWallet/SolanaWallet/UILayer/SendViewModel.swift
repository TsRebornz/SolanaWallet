import Foundation

final class SendViewModel {
    
    private let state: UserData
    private let blockchainClient: BlockchainClient
    
    init(client: BlockchainClient, state: UserData) {
        self.blockchainClient = client
        self.state = state
    }
    
    func sendMoney(_ amount: Int) {
        
    }
}
