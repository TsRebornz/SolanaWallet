import Foundation

protocol NetworkManagerProtocol {
    func getBalance(publicKeyBase58: String, completionHandler: (Result<Data, Error>) -> Void)
}

final class NetworkManager {
    
    private let baseNetwork: BaseNetworkManager
    
    init(network: BaseNetworkManager) {
        self.baseNetwork = network
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func getBalance(publicKeyBase58: String, completionHandler: (Result<Data, Error>) -> Void) {
        guard let getBalanceRequest = SolanaApiRequest.balance(publicKeyBase58: publicKeyBase58).urlRequest else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        baseNetwork.makeRequest(request: getBalanceRequest) { result in
            switch result {
            case .failure(let error):
                print("Error \(error)")
            case .success(let data, let response):
                // FIXME: - Parse response here
                print("data is \(data)")
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
