import Foundation

public class Test {

    private var webSocket: WebSocket?
    
    public init() {
    }
    
    public func testAPI(completion: @escaping ()->()) {

        let address = "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr"
        let symbol = "BNB_BTC.B-918"
        let hashId = "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF"

        let binance = BinanceChain(endpoint: .testnet)

        let group = DispatchGroup()

        group.enter()
        binance.time() { (response) in
            print("times: \(response.time)\n")
            group.leave()
        }

        group.enter()
        binance.nodeInfo() { (response) in
            print("node-info: \(response.nodeInfo)\n")
            group.leave()
        }

        group.enter()
        binance.validators() { (response) in
            print("validators: \(response.validators)\n")
            group.leave()
        }

        group.enter()
        binance.peers() { (response) in
            print("peers: \(response.peers)\n")
            group.leave()
        }

        group.enter()
        binance.account(address: address) { (response) in
            print("account: \(response.account)\n")
            group.leave()
        }

        group.enter()
        binance.sequence(address: address) { (response) in
            print("addresssequence: \(response.sequence)\n")
            group.leave()
        }

        group.enter()
        binance.tx(hash: hashId) { (response) in
            print("tx: \(response.tx)\n")
            group.leave()
        }

        group.enter()
        binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
            print("tokens: \(response.tokens)\n")
            group.leave()
        }

        group.enter()
        binance.markets(limit: .oneHundred, offset: 0) { (response) in
            print("markets: \(response.markets)\n")
            group.leave()
        }

        group.enter()
        binance.fees() { (response) in
            print("fees: \(response.fees)\n")
            group.leave()
        }

        group.enter()
        binance.marketDepth(symbol: symbol) { (response) in
            print("marketdepths: \(response.marketDepth)\n")
            group.leave()
        }

        group.enter()
        binance.broadcast(body: Data()) { (response) in

            group.leave()

        }

        group.enter()
        binance.klines(symbol: symbol, interval: .fiveMinutes) { (response) in
            print("klines: \(response.candlesticks)\n")
            group.leave()
        }

        group.enter()
        binance.closedOrders(address: address) { (response) in
            print("closedorders: \(response.orderList)\n")
            group.leave()
        }

        group.enter()
        binance.openOrders(address: address) { (response) in
            print("openorders: \(response.orderList)\n")
            group.leave()
        }

        group.enter()
        binance.order(id: hashId) { (response) in
            print("order: \(response.order)\n")
            group.leave()
        }

        group.enter()
        binance.ticker(symbol: symbol) { (response) in
            print("ticker: \(response.ticker)\n")
            group.leave()
        }

        group.enter()
        binance.trades() { (response) in
            print("trades: \(response.trades)\n")
            group.leave()
        }

        group.enter()
        binance.transactions(address: address) { (response) in
            print("transactions: \(response.transactions)\n")
            group.leave()
        }

        group.notify(queue: .main) {
            completion()
        }

    }

    public func testWebSocket() {

        self.webSocket = WebSocket()
        self.webSocket?.connect(endpoint: .testnet)

    }

}

