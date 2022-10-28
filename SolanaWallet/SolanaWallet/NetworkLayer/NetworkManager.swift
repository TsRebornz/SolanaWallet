import Foundation

protocol NetworkManagerProtocol {
    func getBalance(publicKeyBase58: String, completionHandler: @escaping (Result<Int, Error>) -> Void)
}

final class NetworkManager {
    
    private let baseNetwork: BaseNetworkManager
    
    init(network: BaseNetworkManager) {
        self.baseNetwork = network
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func getBalance(publicKeyBase58: String, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        guard let getBalanceRequest = SolanaApiRequest.balance(publicKeyBase58: publicKeyBase58).urlRequest else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        baseNetwork.makeRequest(request: getBalanceRequest) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data, let response):
                let response: JSONRPCResponse<Rpc<UInt64>>? = try? JSONRPCResponseDecoder().decode(with: data)
                guard let balance = response?.result?.value else {
                    // FIXME: - Change to proper error
                    completionHandler(.failure(SolanaError.unknown))
                    return
                }
                completionHandler(.success(Int(balance)))
            }
        }
    }
    
    func sendTransaction(transactionString: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let sendTransactionRequest = SolanaApiRequest.transaction(stringTransaction: transactionString) .urlRequest else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        baseNetwork.makeRequest(request: sendTransactionRequest) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data, let response):
                let response: JSONRPCResponse<String>? = try? JSONRPCResponseDecoder().decode(with: data)
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
                    Swift.print("Response body \n Data \(data)")
                    return
                }
                Swift.print("Body \n Json \(jsonObject)")
                
                guard let transactionID = response?.result else {
                    // FIXME: - Change to proper error
                    completionHandler(.failure(SolanaError.unknown))
                    return
                }
                completionHandler(.success(transactionID))
            }
        }
    }
}

final class BaseNetworkManager {
    
    private let urlSession: URLSession
    
    init(networkSession: URLSession) {
        self.urlSession = networkSession
    }
    
    func makeRequest(request: URLRequest, completionHandler: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        let task = urlSession.dataTask(with: request, completionHandler: { maybeData, maybeResponse, maybeError in
            
            if let error = maybeError {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = maybeData,
                  let response = maybeResponse
            else {
                completionHandler(.failure(SolanaError.unknown))
                return
            }
            
            completionHandler(.success((data, response)))
        })
        task.resume()
    }
}
