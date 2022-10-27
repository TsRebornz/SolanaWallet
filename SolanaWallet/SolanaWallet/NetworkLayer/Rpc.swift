public struct Rpc<T: Decodable>: Decodable {
  public let context: Context
  public let value: T
  
  public let gossip: String
  public let tpu: String?
  public let rpc: String?
  public let version: String?
}
