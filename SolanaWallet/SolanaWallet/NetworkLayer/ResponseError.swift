import Foundation

public struct ResponseError: Decodable, Equatable {
    
    public init(code: Int?, message: String?, data: ResponseErrorData?) {
        self.code = code
        self.message = message
        self.data = data
    }

    public let code: Int?
    public let message: String?
    public let data: ResponseErrorData?
}

public struct ResponseErrorData: Decodable, Equatable {
    // public let err: ResponseErrorDataError
    public let logs: [String]?
    public let numSlotsBehind: Int?
}
