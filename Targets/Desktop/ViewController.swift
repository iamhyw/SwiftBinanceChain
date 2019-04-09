//
//  ViewController.swift
//  Desktop
//
//  Created by Michael on 8/4/19.
//

import Cocoa
import BinanceChain

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let address = "tbnb185tqzq3j6y7yep85lncaz9qeectjxqe5054cgn"
        let symbol = "NNB-338_BNB"

        let binance = BinanceChain()

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

        binance.account(address: address)

        binance.sequence(address: address)

        binance.tx(hash: "a-hash-id")

        binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
            print("Found: \(response.tokens.count) tokens")
            response.tokens.forEach({ print("\($0.name) \($0.symbol) \($0.owner)") })
        }

        binance.markets(limit: .oneHundred, offset: 0) { (response) in
            print("Found: \(response.markets.count) markets")
            response.markets.forEach({ print("\($0.baseAssetSymbol) \($0.price)") })
        }

        binance.fees()

        binance.depth(symbol: symbol) { (response) in
            print("Found market depths:")
            print("  asks: \(response.marketDepth.asks)")
            print("  bids: \(response.marketDepth.bids)")
        }
        
        binance.broadcast(body: Data())
        binance.klines(symbol: symbol, interval: .fiveMinutes)
        binance.closedOrders(address: address)
        binance.openOrders(address: address)
        binance.orders(id: "a-hash-id")
        binance.ticker(symbol: symbol)

        binance.trades() { (response) in
            print("Found: \(response.trades.count) trades")
            response.trades.forEach({ print("\($0.symbol) \($0.price)") })
        }
        binance.transactions(address: address)
     
        // Test WebSocket
        let ws = WebSocket()
        ws.connect(endpoint: .test)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

