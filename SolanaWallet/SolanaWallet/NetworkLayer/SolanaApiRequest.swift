import Foundation

let devNetURL = "https://api.devnet.solana.com"

enum SolanaApiRequest: URLConvertable {
   
    case balance(publicKeyBase58: String)
    case transaction(stringTransaction: String)
    
    var headers: [String] {
        return []
    }
    
    var method: String {
        return "POST"
    }
    
    var parameters: Data? {
        let jsonEncoder = JSONEncoder()
        
        let jSONRPCAPIClientRequest: JSONRPCAPIClientRequest<Rpc<UInt32>>
        switch self {
        case .balance(let publicKeyBase58):
            jSONRPCAPIClientRequest = JSONRPCAPIClientRequest(
                method: self.jsonRPCMehtodName,
                params: [publicKeyBase58]
            )
        case .transaction(let stringTransaction):
            jSONRPCAPIClientRequest = JSONRPCAPIClientRequest(
                method: self.jsonRPCMehtodName,
                params: [stringTransaction]
            )
        }
        
        return try? jsonEncoder.encode(jSONRPCAPIClientRequest)
    }
    
    private var jsonRPCMehtodName: String {
        switch self {
        case .balance:
            return "getBalance"
        case .transaction:
            return "sendTransaction"
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: devNetURL) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = parameters
        
        return urlRequest
    }
}
