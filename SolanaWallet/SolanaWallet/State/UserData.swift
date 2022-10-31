import Foundation

final class UserData {
    
    static let current = UserData()
    
    // FIXME: - How to remove force unwrap
    var account: SolanaAccount!
    
    private init() {
        // do nohting
    }
}
