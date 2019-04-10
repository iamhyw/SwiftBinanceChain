## Installation

## Features

- [x] Connect to Production and Testnet
- [x] HTTP API
- [x] WebSockets
- [x] Wallet

## Requirements

- iOS 10.0+ / macOS 10.10+ / tvOS 10.0+ / watchOS 2.0+
- Swift 5.0
- Xcode 10.2

## Installation

### Cocoapods

To integrate BinanceChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'BinanceChain', :git => 'https://github.com/mh7821/BinanceChain/'
```


## Usage

### HTTP API

```swift
import BinanceChain

let binance = BinanceChain(endpoint: .test)

binance.time() { (response) in

    if let error = response.error {
        print(error)
    } else {
        print(response.times)
    }

}

binance.nodeInfo() { (response) in
    print(response.nodeInfo)
}

binance.validators() { (response) in print(response.validators) }

binance.peers() { (response) in
    print(response.peers)
}

binance.account(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.address)
}

binance.sequence(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.sequence)
}

binance.tx(hash: "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF") { (response) in
    print(response.tx)
}

binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
    print(response.tokens)
}

binance.markets(limit: .oneHundred, offset: 0) { (response) in
    print(response.markets)
}

binance.fees() { (response) in
    print(response.fees)
}

binance.marketDepth(symbol: "BNB_BTC.B-918") { (response) in
    print(response.marketDepth)
}

binance.broadcast(body: Data()) { (response) in
    
}

binance.klines(symbol: "BNB_BTC.B-918", interval: .fiveMinutes) { (response) in
    print(response.candlesticks)
}

binance.closedOrders(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.orderList)
}

binance.openOrders(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.orderList)
}

binance.order(id: hashId) { (response) in
    print(response.order)
}

binance.ticker(symbol: "BNB_BTC.B-918") { (response) in
    print(response.ticker)
}

binance.trades() { (response) in
    print(response.trades)
}

binance.transactions(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.transactions)
}
```

### WebSockets

```
let webSocket = WebSocket()
webSocket.connect(endpoint: .test)
```

## License

BinanceChain is released under the MIT license. [See LICENSE](https://github.com/mh7821/Alamofire/blob/master/LICENSE) for details.
