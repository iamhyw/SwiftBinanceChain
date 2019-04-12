import Foundation

public class Test {

    private var webSocket: WebSocket?
    
    public init() {
    }

    public func testAPI(completion: @escaping ()->()) {

        let address = "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr"
        let symbol = "BNB_BTC.B-918"
        let hashId = "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF"
        let orderId = "7F756B1BE93AA2E2FDC3D7CB713ABC206F877802-43"

        let binance = BinanceChain(endpoint: .testnet)

        let group = DispatchGroup()

        group.enter()
        binance.time() { (response) in
            self.output("times", response.time, response.error)
            group.leave()
        }

        group.enter()
        binance.nodeInfo() { (response) in
            self.output("node-info", response.nodeInfo, response.error)
            group.leave()
        }

        group.enter()
        binance.validators() { (response) in
            self.output("validators", response.validators, response.error)
            group.leave()
        }

        group.enter()
        binance.peers() { (response) in
            self.output("peers", response.peers, response.error)
            group.leave()
        }

        group.enter()
        binance.account(address: address) { (response) in
            self.output("account", response.account, response.error)
            group.leave()
        }

        group.enter()
        binance.sequence(address: address) { (response) in
            self.output("addresssequence", response.sequence, response.error)
            group.leave()
        }

        group.enter()
        binance.tx(hash: hashId) { (response) in
            self.output("tx", response.tx, response.error)
            group.leave()
        }

        group.enter()
        binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
            self.output("tokens", response.tokens, response.error)
            group.leave()
        }

        group.enter()
        binance.markets(limit: .oneHundred, offset: 0) { (response) in
            self.output("markets", response.markets, response.error)
            group.leave()
        }

        group.enter()
        binance.fees() { (response) in
            self.output("fees", response.fees, response.error)
            group.leave()
        }

        group.enter()
        binance.marketDepth(symbol: symbol) { (response) in
            self.output("marketdepths", response.marketDepth, response.error)
            group.leave()
        }

        group.enter()
        binance.broadcast(body: Data()) { (response) in
            group.leave()
        }

        group.enter()
        binance.klines(symbol: symbol, interval: .fiveMinutes) { (response) in
            self.output("klines", response.candlesticks, response.error)
            group.leave()
        }

        group.enter()
        binance.closedOrders(address: address) { (response) in
            self.output("closedorders", response.orderList, response.error)
            group.leave()
        }

        group.enter()
        binance.openOrders(address: address) { (response) in
            self.output("openorders", response.orderList, response.error)
            group.leave()
        }

        group.enter()
        binance.order(id: orderId) { (response) in
            self.output("order", response.order, response.error)
            group.leave()
        }

        group.enter()
        binance.ticker(symbol: symbol) { (response) in
            self.output("ticker", response.ticker, response.error)
            group.leave()
        }

        group.enter()
        binance.trades() { (response) in
            self.output("trades", response.trades, response.error)
            group.leave()
        }

        group.enter()
        binance.transactions(address: address) { (response) in
            self.output("transactions", response.transactions, response.error)
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

    public func testWallet() {
        let wallet = Wallet()
        print(wallet.description)
    }
    
    // MARK: - Utils

    private func output(_ label: String, _ property: Any, _ error: Error?) {
        print(String(format: "%@:", label))
        if let error = error {
            print("error: \(error.localizedDescription)\n")
            return
        }
        print(property)
        print("\n")
    }
    
}

