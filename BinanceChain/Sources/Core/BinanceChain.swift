import Foundation
import Alamofire
import SwiftyJSON
import XCGLogger

// https://binance-chain.github.io/api-reference/dex-api/paths.html

public class BinanceChain {

    public struct Result {
    }

    internal enum Path: String {
        case time = "time"
        case nodeInfo = "node-info"
        case validators = "validators"
        case peers = "peers"
        case account = "account"
        case sequence = "sequence"
        case tx = "tx"
        case tokens = "tokens"
        case markets = "markets"
        case fees = "fees"
        case depth = "depth"
        case broadcast = "broadcast"
        case klines = "klines"
        case closedOrders = "orders/closed"
        case openOrders = "orders/open"
        case orders = "orders"
        case ticker = "ticker/24hr"
        case trades = "trades"
        case transactions = "transactions"
    }

    public enum Interval: String {
        case oneMinutes = "1m"
        case threeMinutes = "3m"
        case fiveMinutes = "5m"
        case fifteeninutes = "15m"
        case thirtyMinutes = "30m"
        case oneHour = "1h"
        case twoHours = "2h"
        case fourHours = "4h"
        case sixHours = "6h"
        case eightHours = "8h"
        case twelveHours = "12h"
        case oneDay = "1d"
        case threeDays = "3d"
        case oneWeek = "1w"
        case oneMonth = "1M"
    }

    public enum Limit: Int {
        case five = 5
        case ten = 10
        case twenty = 20
        case fifty = 50
        case oneHundred = 100
        case fiveHundred = 500
        case oneThousand = 1000
    }
    
    public enum Side: Int {
        case buy = 1
        case sell = 2
    }
    
    public enum Status: String {
        case acknowledge = "Ack"
        case partialFill = "PartialFill"
        case iocNoFill = "IocNoFill"
        case fullyFill = "FullyFill"
        case canceled = "Canceled"
        case expired = "Expired"
        case failedBlocking = "FailedBlocking"
        case failedMatching = "FailedMatching"
    }

    public enum Total: Int {
        case notRequired = 0
        case required = 1
    }
    
    public enum TxType: String {
        case newOrder = "NEW_ORDER"
        case issueToken = "ISSUE_TOKEN"
        case burnToken = "BURN_TOKEN"
        case listToken = "LIST_TOKEN"
        case cancelOrder = "CANCEL_ORDER"
        case freezeToken = "FREEZE_TOKEN"
        case unfreezeToken = "UN_FREEZE_TOKEN"
        case transfer = "TRANSFER"
        case proposal = "PROPOSAL"
        case vote = "VOTE"
        case mint = "MINT"
        case deposit = "DEPOSIT"
    }

    public enum TimeInForce: String {
        case goodTillExpire = "GTE"
        case immediateOrCancel = "IOC"
    }
    
    public enum TransactionSide: String {
        case receive = "RECEIVE"
        case send = "SEND"
    }

    public enum OrderType: String {
        case limit = "LIMIT"
        case market = "MARKET"
    }
    
    typealias Completion = ()->()
    typealias Success = (BinanceChain.Result)->()
    typealias Failure = (Error)->()

    public init() {
    }
 
    // MARK: - HTTP API

    public func time() {
        self.api(path: .time, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func nodeInfo() {
        self.api(path: .nodeInfo, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func validators() {
        self.api(path: .validators, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func peers() {
        self.api(path: .peers, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func account(address: String) {
        var parameters: Parameters = [:]
        parameters["address"] = address
        self.api(path: .account, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func sequence(address: String) {
        var parameters: Parameters = [:]
        parameters["format"] = "json"
        let path = String(format: "%@/%@/%@", Path.account.rawValue, address, Path.sequence.rawValue)
        self.api(path: path, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }
    
    public func tx(hash: String) {
        let path = String(format: "%@/%@", Path.tx.rawValue, hash)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func tokens(limit: Limit? = nil, offset: Int? = nil) {
        var parameters: Parameters = [:]
        if let limit = limit { parameters["limit"] = limit.rawValue }
        if let offset = offset { parameters["offset"] = offset }
        self.api(path: .tokens, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func markets(limit: Limit? = nil, offset: Int? = nil) {
        var parameters: Parameters = [:]
        if let limit = limit { parameters["limit"] = limit.rawValue }
        if let offset = offset { parameters["offset"] = offset }
        self.api(path: .markets, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func fees() {
        self.api(path: .fees, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func depth(symbol: String, limit: Limit? = nil) {
        var parameters: Parameters = [:]
        parameters["symbol"] = symbol
        if let limit = limit { parameters["limit"] = limit.rawValue }
        self.api(path: .depth, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func broadcast(sync: Bool? = nil, body: Data) {
        var parameters: Parameters = [:]
        if let sync = sync { parameters["sync"] = (sync) ? "true" : "false" }
        self.api(path: .broadcast, method: .post, parameters: parameters, completion: nil, success: nil, failure: nil)
    }
    
    public func klines(symbol: String, interval: Interval? = nil, limit: Limit? = nil, startTime: TimeInterval? = nil, endTime: TimeInterval? = nil) {
        var parameters: Parameters = [:]
        parameters["symbol"] = symbol
        if let interval = interval { parameters["interval"] = interval.rawValue }
        if let limit = limit { parameters["limit"] = limit }
        if let startTime = startTime { parameters["startTime"] = startTime }
        if let endTime = endTime { parameters["endTime"] = endTime }
        self.api(path: .klines, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func closedOrders(address: String, endTime: TimeInterval? = nil, limit: Limit? = nil, offset: Int? = nil, side: Side? = nil, startTime: TimeInterval? = nil, status: Status? = nil, symbol: String? = nil, total: Total? = nil) {
        var parameters: Parameters = [:]
        parameters["address"] = address
        if let endTime = endTime { parameters["endTime"] = endTime }
        if let limit = limit { parameters["limit"] = limit.rawValue }
        if let offset = offset { parameters["offset"] = offset }
        if let side = side { parameters["side"] = side.rawValue }
        if let startTime = startTime { parameters["startTime"] = startTime }
        if let status = status { parameters["status"] = status.rawValue }
        if let symbol = symbol { parameters["symbol"] = symbol }
        if let total = total { parameters["total"] = total.rawValue }
        self.api(path: .closedOrders, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }
 
    public func openOrders(address: String, limit: Limit? = nil, offset: Int? = nil, symbol: String? = nil, total: Total? = nil) {
        var parameters: Parameters = [:]
        parameters["address"] = address
        if let limit = limit { parameters["limit"] = limit.rawValue }
        if let offset = offset { parameters["offset"] = offset }
        if let symbol = symbol { parameters["symbol"] = symbol }
        if let total = total { parameters["total"] = total.rawValue }
        self.api(path: .openOrders, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func orders(id: String) {
        let path = String(format: "%@/%@", Path.orders.rawValue, id)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func ticker(symbol: String) {
        let path = String(format: "%@/%@", Path.ticker.rawValue, symbol)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func trades(address: String? = nil, buyerOrderId: String? = nil, end: TimeInterval? = nil, height: Double? = nil, offset: Int? = nil, quoteAsset: String? = nil, sellerOrderId: String? = nil, side: Side? = nil, start: TimeInterval? = nil, symbol: String? = nil, total: Total? = nil) {
        var parameters: Parameters = [:]
        parameters["address"] = address
        if let end = end { parameters["end"] = end }
        if let height = height { parameters["height"] = height }
        if let offset = offset { parameters["offset"] = offset }
        if let quoteAsset = quoteAsset { parameters["quoteAsset"] = quoteAsset }
        if let sellerOrderId = sellerOrderId { parameters["sellerOrderId"] = sellerOrderId }
        if let side = side { parameters["side"] = side.rawValue }
        if let start = start { parameters["start"] = start }
        if let symbol = symbol { parameters["symbol"] = symbol }
        if let total = total { parameters["total"] = total.rawValue }
        self.api(path: .trades, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    public func transactions(address: String, blockHeight: Double? = nil, endTime: TimeInterval? = nil, limit: Limit? = nil, offset: Int? = nil, side: Side? = nil, startTime: TimeInterval? = nil, txAsset: String? = nil, txType: TxType? = nil) {
        var parameters: Parameters = [:]
        parameters["address"] = address
        if let blockHeight = blockHeight { parameters["blockHeight"] = blockHeight }
        if let endTime = endTime { parameters["endTime"] = endTime }
        if let limit = limit { parameters["limit"] = limit }
        if let offset = offset { parameters["offset"] = offset }
        if let side = side { parameters["side"] = side.rawValue }
        if let startTime = startTime { parameters["startTime"] = startTime }
        if let txAsset = txAsset { parameters["txAsset"] = txAsset }
        if let txType = txType { parameters["txType"] = txType.rawValue }
        self.api(path: .transactions, method: .get, parameters: parameters, completion: nil, success: nil, failure: nil)
    }

    // MARK: - Utils

    @discardableResult
    internal func api(path: Path, method: HTTPMethod = .get, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, parser: Parser = Parser(), completion: Completion?, success: Success?, failure: Failure?) -> Request? {
        return self.api(path: path.rawValue, method: method, parameters: parameters, encoding: encoding, parser: parser, completion: completion, success: success, failure: failure)
    }
    
    @discardableResult
    internal func api(path: String, method: HTTPMethod = .get, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, parser: Parser = Parser(), completion: Completion?, success: Success?, failure: Failure?) -> Request? {


        let url = String(format: "https://testnet-dex.binance.org/api/v1/%@", path)
        
        print(url)

        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding)
        request.responseData() { (response) -> Void in
            DispatchQueue.global(qos: .background).async {

                switch response.result {
                case .success(let data):
                    
                    print("  \(path) success")

                    let result = BinanceChain.Result()
                    do {
                        
                        if let utf8Text = String(data: data, encoding: .utf8) {
                            print(utf8Text)
                        }
                        
                        try parser.parse(result: result, data: data)

                    } catch {
                        print("  \(path) exception: \(error)")
                        // TODO failure
                        return
                    }

                case .failure(let error):
                    print("  \(path) failure: \(error)")
                    // TODO failure
                    return

                }
                
            }
        }
        return request

    }
    
}
