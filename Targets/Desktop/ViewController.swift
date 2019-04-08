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
        let id = "1"
        
        let binance = BinanceChain()
        binance.time()
        binance.nodeInfo()
        binance.validators()
        binance.peers()
        binance.account(address: address)
        binance.sequence(address: address)
        binance.tx(hash: id)
        binance.tokens()
        binance.markets()
        binance.fees()
        binance.depth(symbol: "xxx-000_BNB")
        binance.broadcast()
        binance.klines(symbol: "NNB-338_BNB", interval: .fiveMinutes)
        binance.closedOrders()
        binance.openOrders()
        binance.orders(id: id)
        binance.ticker()
        binance.trades()
        binance.transactions()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

