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
        self.api(path: .validators, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func account(address: String) {
        let path = String(format: "%@/%@", Path.validators.rawValue, address)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func sequence(address: String) {
        // ?format=json
        let path = String(format: "%@/%@/%@", Path.account.rawValue, address, Path.sequence.rawValue)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func tx(hash: String) {
        let path = String(format: "%@/%@", Path.tx.rawValue, hash)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func tokens() {
        self.api(path: .tokens, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func markets() {
        self.api(path: .markets, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func fees() {
        self.api(path: .fees, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func depth(symbol: String) {
        let path = String(format: "%@?symbol=%@", Path.depth.rawValue, symbol)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func broadcast() {
        self.api(path: .broadcast, method: .post, completion: nil, success: nil, failure: nil)
    }
    
    public func klines(symbol: String, interval: Interval) {
        let path = String(format: "%@?symbol=%@&interval=%@", Path.klines.rawValue, symbol, interval.rawValue)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func closedOrders() {
        self.api(path: .closedOrders, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func openOrders() {
        self.api(path: .openOrders, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func orders(id: String) {
        let path = String(format: "%@/%@", Path.orders.rawValue, id)
        self.api(path: path, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func ticker() {
        self.api(path: .ticker, method: .get, completion: nil, success: nil, failure: nil)
    }
    
    public func trades() {
        self.api(path: .trades, method: .get, completion: nil, success: nil, failure: nil)
    }

    public func transactions() {
        self.api(path: .transactions, method: .get, completion: nil, success: nil, failure: nil)
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
