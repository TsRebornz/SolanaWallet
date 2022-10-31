import Foundation

extension Array where Element == SolanaAccount.Meta {
    func index(ofElementWithPublicKey publicKey: PublicKey) throws -> Int {
        guard let index = firstIndex(where: { $0.publicKey == publicKey })
        else { throw SolanaError.other("Could not found accountIndex") }
        return index
    }
}
