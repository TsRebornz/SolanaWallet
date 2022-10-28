import Foundation

public struct Fee: Decodable {
    public let feeCalculator: FeeCalculatorResponse?
    public let feeRateGovernor: FeeRateGovernor?
    public let blockhash: String?
    public let lastValidSlot: UInt64?
}

public struct FeeCalculatorResponse: Decodable {
    public let lamportsPerSignature: UInt64
}

public struct FeeRateGovernor: Decodable {
    public let burnPercent: UInt64
    public let maxLamportsPerSignature: UInt64
    public let minLamportsPerSignature: UInt64
    public let targetLamportsPerSignature: UInt64
    public let targetSignaturesPerSlot: UInt64
}
