//
//  ViewController.swift
//  Desktop
//
//  Created by Michael on 8/4/19.
//

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
            print("Found times:")
            print("  apTime: \(response.times.apTime)")
            print("  blockTime: \(response.times.blockTime)")
        }

        binance.nodeInfo() { (response) in
            print("Found node info: \(response.nodeInfo.address) \(response.nodeInfo.version) \(response.nodeInfo.moniker)")
        }

        binance.validators() { (response) in
            print("Found \(response.validators.validators.count) validators:")
            response.validators.validators.forEach({ print("\($0.address) \($0.votingPower)") })
        }

        binance.peers() { (response) in
            print("Found: \(response.peers.count) peers")
            response.peers.forEach({ print("\($0.id) \($0.listenAddr)") })
        }

        binance.account(address: address) { (response) in
            print("Found account: \(response.account.address) with \(response.account.balances.count) balances")
            response.account.balances.forEach({ print("\($0.symbol) \($0.free)") })
        }

        binance.sequence(address: address) { (response) in
            print("Found sequence number: \(response.sequence)")
        }

        binance.tx(hash: hashId) { (response) in
            print("Found Tx: \(response.tx.txHash) \(response.tx.txType)")
        }

        binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
            print("Found: \(response.tokens.count) tokens")
            response.tokens.forEach({ print("\($0.name) \($0.symbol) \($0.owner)") })
        }

        binance.markets(limit: .oneHundred, offset: 0) { (response) in
            print("Found: \(response.markets.count) markets")
            response.markets.forEach({ print("\($0.baseAssetSymbol) \($0.price)") })
        }

        binance.fees() { (response) in
            print("Found: \(response.fees.count) fees")
            response.fees.forEach({ print("\($0.msgType) \($0.fee)") })
        }

        binance.marketDepth(symbol: symbol) { (response) in
            print("Found market depths:")
            print("  asks: \(response.marketDepth.asks)")
            print("  bids: \(response.marketDepth.bids)")
        }
        
        binance.broadcast(body: Data()) { (response) in
            
        }

        binance.klines(symbol: symbol, interval: .fiveMinutes) { (response) in
            print("Found: \(response.candlesticks.count) candlesticks")
            response.candlesticks.forEach({ print("\($0.close) \($0.closeTime) \($0.numberOfTrades)") })
        }

        binance.closedOrders(address: address) { (response) in
            print("Found \(response.orderList.orders.count) closed orders")
            response.orderList.orders.forEach({ print("\($0.symbol) \($0.orderId)") })
        }

        binance.openOrders(address: address) { (response) in
            print("Found \(response.orderList.orders.count) open orders")
            response.orderList.orders.forEach({ print("\($0.symbol) \($0.orderId)") })
        }

        binance.order(id: hashId) { (response) in
            print("Found order: \(response.order.symbol) \(response.order.orderId)")
        }

        binance.ticker(symbol: symbol) { (response) in
            print("Found: \(response.tickerStatistics.count) ticker statistics")
            response.tickerStatistics.forEach({ print("\($0.symbol) \($0.volume) \($0.bidPrice)") })
        }

        binance.trades() { (response) in
            print("Found: \(response.trades.count) trades")
            response.trades.forEach({ print("\($0.symbol) \($0.price)") })
        }

        binance.transactions(address: address) { (response) in
            print("Found \(response.transactions.total) transactions:")
            response.transactions.tx.forEach({ print("\($0.txHash) \($0.txType)") })
        }
     
        // Test WebSocket
        self.webSocket = WebSocket()
        self.webSocket?.connect(endpoint: .test)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

