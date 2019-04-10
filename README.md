# Swift Binance Chain SDK

![Swift: 5.0](https://img.shields.io/badge/swift-5.0-brightgreen.svg)
![Platforms: ios | macos | watchos | tvos](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos-blue.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-ff69b4.svg)
![Version: alpha](https://img.shields.io/badge/version-alpha-orange.svg)

## Installation

## Features

- [x] Connect to Production and Testnet
- [x] HTTP API
- [x] WebSockets
- [x] Wallet

## Requirements

- iOS 10.0+ / macOS 10.10+ / tvOS 10.0+ / watchOS 2.0+
- Swift 5.0+
- Xcode 10.2+

## Installation

### Cocoapods

To integrate BinanceChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'BinanceChain', :git => 'https://github.com/mh7821/BinanceChain/'
```

## Usage

```swift
import BinanceChain

let binance = BinanceChain()

// Get the latest block time and current time
binance.time() { (response) in

    if let error = response.error {
        print(error)
    } else {
        print(response.time)
    }

}

// Get node information
binance.nodeInfo() { (response) in
    print(response.nodeInfo)
}

// Get the list of validators used in consensus
binance.validators() { (response) in
    print(response.validators)
}

// Get the list of network peers
binance.peers() { (response) in
    print(response.peers)
}

// Get account metadata for an address
binance.account(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.address)
}

// Get an account sequence
binance.sequence(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.sequence)
}

// Get a transaction
binance.tx(hash: "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF") { (response) in
    print(response.tx)
}

// Get token list
binance.tokens(limit: .fiveHundred, offset: 0) { (response) in
    print(response.tokens)
}

// Get market pairs
binance.markets(limit: .oneHundred, offset: 0) { (response) in
    print(response.markets)
}

// Obtain trading fees information
binance.fees() { (response) in
    print(response.fees)
}

// Get the order book
binance.marketDepth(symbol: "BNB_BTC.B-918") { (response) in
    print(response.marketDepth)
}

// Broadcast a transaction
binance.broadcast(body: Data()) { (response) in
    
}

// Get candlestick/kline bars for a symbol
binance.klines(symbol: "BNB_BTC.B-918", interval: .fiveMinutes) { (response) in
    print(response.candlesticks)
}

// Get closed (filled and cancelled) orders for an address
binance.closedOrders(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.orderList)
}

// Get open orders for an address
binance.openOrders(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.orderList)
}

// Get an order
binance.order(id: hashId) { (response) in
    print(response.order)
}

// Get 24 hour price change statistics for a market pair symbol
binance.ticker(symbol: "BNB_BTC.B-918") { (response) in
    print(response.ticker)
}

// Get a list of historical trades
binance.trades() { (response) in
    print(response.trades)
}

// Get transactions for an address
binance.transactions(address: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr") { (response) in
    print(response.transactions)
}
```

### WebSockets

```swift
let webSocket = WebSocket()
webSocket.connect(endpoint: .test)
```

### Testnet

Switch between production and testnet easily:

```swift
let binance = BinanceChain(endpoint: .production)
let websocket = WebSocket(endpoint: .test)
```

## Sample apps

Sample iOS and macOS apps are provided. First, use CocoaPods to install the dependencies:

```console
% pod install
```

Then open `BinanceChain.xcworkspace`.

## In Progress



## License

BinanceChain is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/mh7821/SwiftBinanceChain/master/LICENSE) for details.
