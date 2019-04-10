import Cocoa
import BinanceChain

class ViewController: NSViewController {

    private var webSocket: WebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let address = "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr"
        let symbol = "BNB_BTC.B-918"
        let hashId = "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF"

        let binance = BinanceChain(endpoint: .test)

        binance.time() { (response) in
            print("time: \(response.time)\n")
        }

        binance.nodeInfo() { (response) in
            print("node info: \(response.nodeInfo)\n")
        }

        binance.validators() { (response) in
            print("validators: \(response.validators)\n")
        }

        binance.peers() { (response) in
            print("peers: \(response.peers)\n")
        }

        binance.account(address: address) { (response) in
            print("account: \(response.account)\n")
        }

        binance.sequence(address: address) { (response) in
            print("addresssequence: \(response.sequence)\n")
        }

        binance.tx(hash: hashId) { (response) in
            print("tx: \(response.tx)\n")
        }

        binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
            print("tokens: \(response.tokens)\n")
        }

        binance.markets(limit: .oneHundred, offset: 0) { (response) in
            print("markets: \(response.markets)\n")
        }

        binance.fees() { (response) in
            print("Found: \(response.fees)\n")
        }

        binance.marketDepth(symbol: symbol) { (response) in
            print("marketdepths: \(response.marketDepth)\n")
        }
        
        binance.broadcast(body: Data()) { (response) in
            
        }

        binance.klines(symbol: symbol, interval: .fiveMinutes) { (response) in
            print("klines: \(response.candlesticks)\n")
        }

        binance.closedOrders(address: address) { (response) in
            print("closedorders: \(response.orderList)\n")
        }

        binance.openOrders(address: address) { (response) in
            print("openorders: \(response.orderList)\n")
        }

        binance.order(id: hashId) { (response) in
            print("order: \(response.order)\n")
        }

        binance.ticker(symbol: symbol) { (response) in
            print("Found: \(response.ticker)\n")
        }

        binance.trades() { (response) in
            print("trades: \(response.trades)\n")
        }

        binance.transactions(address: address) { (response) in
            print("transactions: \(response.transactions)\n")
        }

        // Test WebSocket
        self.webSocket = WebSocket()
        self.webSocket?.connect(endpoint: .test)
        
    }

}

