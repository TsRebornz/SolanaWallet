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
            case .success(let data, let _):
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
        guard let sendTransactionRequest = SolanaApiRequest.transaction(stringTransaction: transactionString).urlRequest
        else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        baseNetwork.makeRequest(request: sendTransactionRequest) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data, let _):
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
    
    func recentBlockHash(completionHandler: @escaping (Result<Fee, Error>) -> Void) {
        guard let recentBlockHashRequest = SolanaApiRequest.recentBlockHash.urlRequest
        else {
            completionHandler(.failure(SolanaError.unknown))
            return
        }
        
        baseNetwork.makeRequest(request: recentBlockHashRequest) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data, let _):
                let response: JSONRPCResponse<Rpc<Fee>>? = try? JSONRPCResponseDecoder().decode(with: data)
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
                    Swift.print("Response body \n Data \(data)")
                    return
                }
                Swift.print("Body \n Json \(jsonObject)")
                
                guard let fee = response?.result?.value else {
                    // FIXME: - Change to proper error
                    completionHandler(.failure(SolanaError.unknown))
                    return
                }
                completionHandler(.success(fee))
            }
        }
    }
    
    /*
         /// Send preparedTransaction
         /// - Parameter preparedTransaction: preparedTransaction to be sent
         /// - Returns: Transaction signature
         func sendTransaction(
             preparedTransaction: PreparedTransaction
         ) async throws -> String {
             try await Task.retrying(
                 where: { $0.isBlockhashNotFoundError },
                 maxRetryCount: 3,
                 retryDelay: 1,
                 timeoutInSeconds: 60
             ) {
                 let recentBlockhash = try await self.apiClient.getRecentBlockhash()
                 let serializedTransaction = try self.signAndSerialize(
                     preparedTransaction: preparedTransaction,
                     recentBlockhash: recentBlockhash
                 )
                 return try await self.apiClient.sendTransaction(
                     transaction: serializedTransaction,
                     configs: RequestConfiguration(encoding: "base64")!
                 )
             }
             .value
         }
     
     
         /// Simulate transaction (for testing purpose)
         /// - Parameter preparedTransaction: preparedTransaction to be simulated
         /// - Returns: The result of Simulation
         func simulateTransaction(
             preparedTransaction: PreparedTransaction
         ) async throws -> SimulationResult {
             try await Task.retrying(
                 where: { $0.isBlockhashNotFoundError },
                 maxRetryCount: 3,
                 retryDelay: 1,
                 timeoutInSeconds: 60
             ) {
                 let recentBlockhash = try await self.apiClient.getRecentBlockhash()
                 let serializedTransaction = try self.signAndSerialize(
                     preparedTransaction: preparedTransaction,
                     recentBlockhash: recentBlockhash
                 )
                 return try await self.apiClient.simulateTransaction(
                     transaction: serializedTransaction,
                     configs: RequestConfiguration(encoding: "base64")!
                 )
             }
             .value
         }
     */
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
