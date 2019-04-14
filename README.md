# Binance Chain Swift SDK

![Version: beta](https://img.shields.io/badge/version-1.0.0--beta-orange.svg)
![Platforms: ios | macos | watchos | tvos](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos-blue.svg)
![Swift: 5.0](https://img.shields.io/badge/swift-5.0-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-ff69b4.svg)

## Features

- [x] Connect to mainnet, testnet, or a custom address
- [x] HTTP API
- [x] Wallet
- [x] WebSockets
- [x] Broadcast Transactions

## Requirements

- iOS 11+ / macOS 10.10+ / tvOS 11+ / watchOS 2+
- Swift 5
- Xcode 10.2

## Installation

### Swift Package Manager

To add BinanceChain to your project, add a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/mh7821/BinanceChain.git", from: "0.0.0")
]
```

### Cocoapods

To integrate BinanceChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'BinanceChain', :git => 'https://github.com/mh7821/BinanceChain.git'
```

## Usage

Asynchronous API calls can be made using [BinanceChain](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/BinanceChain.swift). The response objects are strongly typed, see [Model](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Core/Model.swift) for available properties.

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
let wallet = Wallet(mnemonic: "mnemonic word list")

// Sign a message
let data = wallet.sign(message: data)

// Access wallet
print(wallet.address)
print(wallet.privateKey)
print(wallet.publicKey)

```

### Broadcast Transactions

Broadcast messages are a work in progress. Signing is not complete and these interfaces may change.

```swift
let binance = BinanceChain()
let wallet = Wallet()

// Create a new order to buy or sell tokens
let msg = NewOrderMessage(symbol: "BNB_BTC.B-918", orderType: .limit, side: .buy, price: 100,
                          quantity: 1, timeInForce: .goodTillExpire, wallet: wallet)

// Cancel an outstanding (unfilled) order
let msg = CancelOrderMessage(symbol: "BNB_BTC.B-918", orderId: "id", wallet: wallet)

// Transfer funds
let msg = TransferMessage(denom: "BNB", amount: 200, to: "tbnb1066kkxlf823w9lwr6l9hzw4uyphcw7q22ud2ry",
                          toDenom: "BNB", toAmount: 200, wallet: wallet)

// Move tokens into a frozen state, meaning they can't be used to transfer or send new orders
let msg = FreezeMessage(symbol: "BNB_BTC.B-918", amount: 10, wallet: wallet)

// Reverse tokens back into a free state
let msg = UnFreezeMessage(symbol: "BNB_BTC.B-18", amount: 10, wallet: wallet)

// Vote for proposals
let vote = VoteMessage(proposalId: 1, vote: .yes, wallet: wallet)

// Broadcast the message
binance.broadcast(message: msg, sync: true) { (response) in
    if let error = response.error { return print(error) }
    print(response)
}

```

### Changing networks

Switch between mainnet, testnet, or a custom endpoint easily:

```swift
let binance = BinanceChain(endpoint: .mainnet)
let websocket = WebSocket(endpoint: .testnet)
let wallet = Wallet(endpoint: "https://dex.binance.org/api/v1")
```

## Sample apps

Sample apps are provided for iOS and macOS. They use [Test.swift](https://github.com/mh7821/SwiftBinanceChain/blob/master/BinanceChain/Sources/Util/Test.swift) to demonstrate all features of the library.

The command line app uses Swift Package Manager:

```console
% swift run binancechain [test]

Available tests:

        all: Run everything
        api: HTTP API
  websocket: Websockets
  broadcast: Broadcast Transactions
     wallet: Wallet
```

The iOS and macOS apps use Cocoapods and Xcode:

```console
% pod install
% open BinanceChain.xcworkspace
```

## In Progress

* Broadcast message signing

## License

BinanceChain is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/mh7821/SwiftBinanceChain/master/LICENSE) for details.
