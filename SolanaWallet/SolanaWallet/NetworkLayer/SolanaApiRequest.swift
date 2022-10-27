import Foundation

let devNetURL = "https://api.devnet.solana.com"

/*
 // Get balance usage example
    public func getBalance(account: String, commitment: Commitment? = nil) async throws -> UInt64 {
         let response: Rpc<UInt64> = try await get(method: "getBalance", params: [
             account,
             RequestConfiguration(commitment: commitment)
         ])
         return response.value
     }
 */

/*
 
 // MARK: - Private

     private func get<Entity: Decodable>(method: String, params: [Encodable]) async throws -> Entity {
         let request = RequestEncoder.RequestType(method: method, params: params)
         let data = try await makeRequest(request: request)
         let response: AnyResponse<Entity> = try ResponseDecoder<AnyResponse<Entity>>().decode(with: data)
         if let error = response.error {
             Logger.log(
                 event: "SolanaSwift: get<Entity>",
                 message: (String(data: data, encoding: .utf8) ?? "") + "\n" + (error.message ?? ""),
                 logLevel: .error
             )
             throw APIClientError.responseError(error)
         }
         guard let result = response.result else {
             Logger.log(
                 event: "SolanaSwift: get<Entity>",
                 message: String(data: data, encoding: .utf8),
                 logLevel: .error
             )
             throw APIClientError.invalidResponse
         }
         return result
     }
     
     private func makeRequest(request: RequestEncoder.RequestType) async throws  -> Data {
         var encodedParams = Data()
         do {
             encodedParams += try RequestEncoder(request: request).encoded()
         } catch {
             Logger.log(
                 event: "SolanaSwift: makeRequest",
                 message: "Can't encode params \(String(data: encodedParams, encoding: .utf8))",
                 logLevel: .error
             )
             throw APIClientError.cantEncodeParams
         }
         try Task.checkCancellation()
         let responseData = try await networkManager.requestData(request: try urlRequest(data: encodedParams))

         // log
         Logger.log(event: "response", message: String(data: responseData, encoding: .utf8) ?? "", logLevel: .debug)

         return responseData
         
     }

     private func makeRequest(requests: [RequestEncoder.RequestType]) async throws -> Data {
         var encodedParams = Data()
         do {
             encodedParams += try RequestEncoder(requests: requests).encoded()
         } catch {
             Logger.log(
                 event: "SolanaSwift: makeRequest",
                 message: "Can't encode params \(String(data: encodedParams, encoding: .utf8))",
                 logLevel: .error
             )
             throw APIClientError.cantEncodeParams
         }
         try Task.checkCancellation()
         let responseData = try await networkManager.requestData(request: try urlRequest(data: encodedParams))

         // log
         Logger.log(event: "response", message: String(data: responseData, encoding: .utf8) ?? "", logLevel: .debug)

         return responseData
     }

     private func urlRequest(data: Data) throws -> URLRequest {
         guard let url = URL(string: endpoint.getURL()) else { throw APIClientError.invalidAPIURL }
         var urlRequest = URLRequest(url: url)
         urlRequest.httpBody = data
         urlRequest.httpMethod = "POST"
         urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

         // log
         Logger.log(event: "request", message: urlRequest.cURL(), logLevel: .debug)

         return urlRequest
     }
 */


enum SolanaApiRequest: URLConvertable {
   
    case balance(publicKeyBase58: String)
    
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
        }
        
        return try? jsonEncoder.encode(jSONRPCAPIClientRequest)
    }
    
    private var jsonRPCMehtodName: String {
        switch self {
        case .balance:
            return "getBalance"
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

/*
     {
        "jsonrpc": "2.0",
        "result": {
            "context": {
                "slot": 1
            },
            "value": 0
        },
        "id": 1
     }
 */
