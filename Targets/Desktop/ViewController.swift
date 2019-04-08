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
        binance.time()
        binance.nodeInfo()
        binance.validators()
        binance.peers()
        binance.account(address: address)
        binance.sequence(address: address)
        binance.tx(hash: "a-hash-id")
        binance.tokens(limit: .fiveHundred, offset: 0)
        binance.markets(limit: .oneHundred, offset: 0)
        binance.fees()
        binance.depth(symbol: symbol)
        binance.broadcast(body: Data())
        binance.klines(symbol: symbol, interval: .fiveMinutes)
        binance.closedOrders(address: address)
        binance.openOrders(address: address)
        binance.orders(id: "a-hash-id")
        binance.ticker(symbol: symbol)
        binance.trades()
        binance.transactions(address: address)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

