import Foundation
import Starscream
import SwiftyJSON

public protocol WebSocketDelegate {
    func webSocketDidConnect(webSocket: WebSocket)
    func webSocketDidDisconnect(webSocket: WebSocket)
    func webSocket(webSocket: WebSocket, orders: [Order])
    func webSocket(webSocket: WebSocket, accounts: [Account])
//    func webSocket(webSocket: WebSocket, transfers: [Transfer])
    func webSocket(webSocket: WebSocket, trades: [Trade])
//    func webSocket(webSocket: WebSocket, marketDiff: MarketDiff)
    func webSocket(webSocket: WebSocket, marketDepth: MarketDepth)
    func webSocket(webSocket: WebSocket, candlestick: Candlestick)
    func webSocket(webSocket: WebSocket, ticker: TickerStatistics)
    func webSocket(webSocket: WebSocket, miniTicker: TickerStatistics)
    func webSocket(webSocket: WebSocket, miniTickers: [TickerStatistics])
    func webSocket(webSocket: WebSocket, blockHeight: TickerStatistics)
}

public class WebSocket {

    public enum Endpoint: String {
        case mainnet = "wss://dex.binance.org/api/ws"
        case testnet = "wss://testnet-dex.binance.org/api/ws"
    }

    public struct Subscription {
        internal var message: Message
    }

    public var delegate: WebSocketDelegate!

    internal enum Method: String {
        case subscribe = "subscribe"
        case unsubscribe = "unsubscribe"
    }

    internal enum Topic: String {
        case orders = "orders"
        case accounts = "accounts"
        case transfers = "transfers"
        case trades = "trades"
        case marketDiff = "marketDiff"
        case marketDepth = "marketDepth"
        case kline = "kline_%@"
        case ticker = "ticker"
        case allTickers = "allTickers"
        case miniTicker = "miniTicker"
        case allMiniTickers = "allMiniTickers"
        case blockHeight = "blockheight"
    }
    
    internal enum Parameter: String {
        case topic = "topic"
        case address = "address"
        case userAddress = "userAddress"
        case symbols = "symbols"
    }

    public enum Symbols: String {
        case all = "$all"
    }
    
    internal struct Message {

        var method: Method = .subscribe
        var topic: String = ""
        var parameters: [Parameter:Any] = [:]

        init(method: Method, topic: String, parameters: [Parameter:Any]) {
            self.method = method
            self.topic = topic
            self.parameters = parameters
        }

        init(method: Method, topic: Topic, parameters: [Parameter:Any]) {
            self.init(method: method, topic: topic.rawValue, parameters: parameters)
        }

        var json: String {
            var message: [String:Any] = [:]
            message["method"] = self.method.rawValue
            message["topic"] = self.topic
            self.parameters.forEach({ message[$0.0.rawValue] = $0.1 })
            return JSON(message).rawString() ?? "{}"
        }

    }

    private var socket: Starscream.WebSocket!

    public init(delegate: WebSocketDelegate, endpoint: Endpoint = .testnet) {
        self.delegate = delegate

        self.socket = Starscream.WebSocket(url: URL(string: endpoint.rawValue)!)
        self.socket.onConnect = { self.onConnect() }
        self.socket.onText = { (text: String) in self.onText(text: text) }
        self.socket.onData = { (data: Data) in self.onData(data: data) }
        self.socket.onPong = { (data: Data?) in self.onPong(data: data) }
        self.socket.onDisconnect = { (error: Error?) in self.onDisconnect() }

    }
    
    public func connect(endpoint: Endpoint = .testnet) {
        self.socket.connect()
    }
    
    public func disconnect() {
        self.socket.disconnect()
    }

    private func send(message: Message) -> Subscription {
        print(message.json)
        self.socket.write(string: message.json)
        return Subscription(message: message)
    }
    
    // MARK: - Subscribe

    @discardableResult
    public func subscribe(orders address: String) -> Subscription {
        let message = Message(method: .subscribe, topic: .orders, parameters: [.userAddress: address])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(accounts address: String) -> Subscription {
        let message = Message(method: .subscribe, topic: .accounts, parameters: [.userAddress: address])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(transfer address: String) -> Subscription {
        let message = Message(method: .subscribe, topic: .accounts, parameters: [.userAddress: address])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(trades symbols: [String]) -> Subscription {
        let message = Message(method: .subscribe, topic: .trades, parameters: [.symbols: symbols])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(marketDiff symbols: [String]) -> Subscription {
        let message = Message(method: .subscribe, topic: .marketDiff, parameters: [.symbols: symbols])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(marketDepth symbols: [String]) -> Subscription {
        let message = Message(method: .subscribe, topic: .marketDepth, parameters: [.symbols: symbols])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(candlestick symbols: [String], interval: Interval) -> Subscription {
        let topic = String(format: Topic.kline.rawValue, interval.rawValue)
        let message = Message(method: .subscribe, topic: topic, parameters: [.symbols: symbols])
        return self.send(message: message)
    }
    
    @discardableResult
    public func subscribe(ticker symbols: [String]) -> Subscription {
        let message = Message(method: .subscribe, topic: .ticker, parameters: [.symbols: symbols])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(ticker symbols: Symbols) -> Subscription {
        let message = Message(method: .subscribe, topic: .allTickers, parameters: [.symbols: [symbols.rawValue]])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(miniTicker symbols: [String]) -> Subscription {
        let message = Message(method: .subscribe, topic: .miniTicker, parameters: [.symbols: symbols])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(miniTicker symbols: Symbols) -> Subscription {
        let message = Message(method: .subscribe, topic: .allMiniTickers, parameters: [.symbols: [symbols.rawValue]])
        return self.send(message: message)
    }

    @discardableResult
    public func subscribe(blockheight symbols: Symbols) -> Subscription {
        let message = Message(method: .subscribe, topic: .blockHeight, parameters: [.symbols: [symbols.rawValue]])
        return self.send(message: message)
    }

    // MARK: - Unsubscribe

    public func unsubscribe(subscription: Subscription) {
        var message = subscription.message
        message.method = .unsubscribe
        _ = self.send(message: message)
    }

    // MARK: - Starscream
    
    private func onConnect() {
        self.delegate.webSocketDidConnect(webSocket: self)
    }

    private func onDisconnect() {
        self.delegate.webSocketDidConnect(webSocket: self)
    }
    
    private func onText(text: String) {
        print("RECEIVED:")
        print(text)
//        self.delegate.webSocketDidConnect(webSocket: self)
    }
    
    private func onData(data: Data) {
    }
    
    private func onPong(data: Data?) {
        print("PONG")
    }
    
}
