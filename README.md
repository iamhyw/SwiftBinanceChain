# Binance Chain Swift SDK

![Version: alpha](https://img.shields.io/badge/version-1.0.0--alpha-orange.svg)
![Platforms: ios | macos | watchos | tvos](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos-blue.svg)
![Swift: 5.0](https://img.shields.io/badge/swift-5.0-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-ff69b4.svg)

## Features

- [x] Connect to mainnet, testnet, or a custom address
- [x] HTTP API
- [x] WebSockets
- [x] Wallet

## Requirements

- iOS 10+ / macOS 10.10+ / tvOS 10+ / watchOS 2+
- Swift 5
- Xcode 10.2

## Installation

### Swift Package Manager

To add BinanceChain to your project, add a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/mh7821/BinanceChain.git", from: "1.0.0-alpha")
]
```

### Cocoapods

To integrate BinanceChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'BinanceChain', :git => 'https://github.com/mh7821/BinanceChain/'
```

## Usage

Asynchronous API calls can be made using an instance of [BinanceChain](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/BinanceChain.swift). The response objects are strongly typed, see [Model](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/Model.swift) for available properties.

```swift
import BinanceChain

let binance = BinanceChain()

// Get the latest block time and current time
binance.time() { (response) in
    if let error = response.error { return print(error) }
    print(response.time)
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

To get real-time updates, create a [WebSocket](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/WebSocket.swift), register a [WebSocketDelegate](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/WebSocket.swift), connect and subscribe. The delegate will be notified as updates become available.

```swift
import BinanceChain

let webSocket = WebSocket()
webSocket.delegate = self
webSocket.connect(endpoint: .testnet) {

    // Individual order updates
    webSocket.subscribe(accounts: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr")
    
    // Account updates
    webSocket.subscribe(orders: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr")
    
    // Transfer updates when the address is sender or receiver
    webSocket.subscribe(transfer: "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr")
    
    // Individual trade updates
    webSocket.subscribe(trades: ["BNB_BTC.B-918"])
    
    // Order book price and quantity depth updates
    webSocket.subscribe(marketDiff: ["BNB_BTC.B-918"])
    
    // Top 20 levels of bids and asks
    webSocket.subscribe(marketDepth: ["BNB_BTC.B-918"])
    
    // The current candlestick at requested interval
    webSocket.subscribe(candlestick: ["BNB_BTC.B-918"], interval: .oneMinute)
    
    // Ticker statistics for a symbol, sent every second
    webSocket.subscribe(ticker: ["BNB_BTC.B-918"])
    
    // Ticker statistics for all symbols, sent every second
    webSocket.subscribe(ticker: .all)
    
    // Reduced ticker statistics for a symbol, sent every second
    webSocket.subscribe(miniTicker: ["BNB_BTC.B-918"])
    
    // Reduced ticker statistics all symbols, sent every second
    webSocket.subscribe(miniTicker: .all)
    
    // Latest block height
    webSocket.subscribe(blockheight: .all)

    // Keep a reference in order to unsubscribe
    let subscription = webSocket.subscribe(ticker: all)
    webSocket.unsubscribe(subscription)

}
```

### Wallet

```swift
import BinanceChain

// Generate a random wallet
let wallet = Wallet()

// Restore with a mnemonic
let wallet = Wallet(mnemonic: "quality mind spend rigid ladder toast settle toward nature drop witness phrase")
```

### Alternating networks

Switch between mainnet, testnet, or a custom endpoint easily:

```swift
let binance = BinanceChain(endpoint: .mainnet)
let websocket = WebSocket(endpoint: .testnet)
let wallet = Wallet(endpoint: "https://dex.binance.org/api/v1")
```

## Sample apps

A command line app demonstrates all features of the library. Run with:

```console
% swift run
```

Sample iOS and macOS apps run the same demonstration. To run:

```console
% pod install
% open BinanceChain.xcworkspace
```

## In Progress

* Model object types
* Broadcast messages
* WebSockets

## License

BinanceChain is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/mh7821/SwiftBinanceChain/master/LICENSE) for details.
