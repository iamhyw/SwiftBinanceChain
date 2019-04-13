import Foundation

public protocol TestDelegate {
    func testComplete(label: String, property: Any, error: Error?)
}

public class Test: WebSocketDelegate {

    private let address = "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr"
    private let addressTwo = "tbnb10a6kkxlf823w9lwr6l9hzw4uyphcw7qzrud5rr"
    private let symbol = "BNB_BTC.B-918"
    private let hashId = "5CAA5E0C6266B3BB6D66C00282DFA0A6A2F9F5A705E6D9049F619B63E1BE43FF"
    private let orderId = "7F756B1BE93AA2E2FDC3D7CB713ABC206F877802-43"
    private let amount = 200

    public var delegate: TestDelegate?
    
    public init() {
    }

    // MARK: - Test
    
    public func runAllTestsOnTestnet() {

        self.testAPI(endpoint: .testnet) {
            self.testWallet(endpoint: .testnet)
            self.testBroadcast(endpoint: .testnet)
            self.testWebSocket(endpoint: .testnet)
        }

    }

    // MARK: - API
    
    public func testAPI(endpoint: BinanceChain.Endpoint = .testnet, completion: @escaping ()->()) {

        let binance = BinanceChain(endpoint: endpoint)
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
        binance.broadcast(message: Data()) { (response) in
            self.output("broadcast", "error is expected", response.error)
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

    // MARK: - API: Broadcast
    
    public func testBroadcast(endpoint: BinanceChain.Endpoint = .testnet) {

        let binance = BinanceChain(endpoint: endpoint)
        let wallet = Wallet(endpoint: endpoint)

        let msgNewOrder = NewOrderMessage(symbol: symbol, orderType: .limit, side: .buy, price: 100,
                                          quantity: 1, timeInForce: .goodTillExpire, wallet: wallet)
        binance.broadcast(message: msgNewOrder) { (response) in
            self.output("broadcast.neworder", response, response.error)
        }

        let msgCancel = CancelMessage(symbol: symbol, orderId: orderId, wallet: wallet)
        binance.broadcast(message: msgCancel) { (response) in
            self.output("broadcast.cancel", response, response.error)
        }

        let msgTransfer = TransferMessage(from: address, fromDenom: symbol, fromAmount: amount,
                                   to: addressTwo, toDenom: symbol, toAmount: amount, wallet: wallet)
        binance.broadcast(message: msgTransfer) { (response) in
            self.output("broadcast.transfer", response, response.error)
        }

        let msgFreeze = FreezeMessage(symbol: symbol, amount: amount, wallet: wallet)
        binance.broadcast(message: msgFreeze) { (response) in
            self.output("broadcast.freeze", response, response.error)
        }

        let msgUnFreeze = UnFreezeMessage(symbol: symbol, amount: amount, wallet: wallet)
        binance.broadcast(message: msgUnFreeze) { (response) in
            self.output("broadcast.unfreeze", response, response.error)
        }

        let vote = VoteMessage(proposalId: 1, vote: .yes, address: address, wallet: wallet)
        binance.broadcast(message: vote) { (response) in
            self.output("broadcast.vote", response, response.error)
        }

    }
    
    // MARK: - WebSocket

    private var webSocket: WebSocket?

    public func testWebSocket(endpoint: WebSocket.Endpoint = .testnet) {

        let webSocket = WebSocket(delegate: self)
        self.webSocket = webSocket
        webSocket.connect(endpoint: endpoint) {

            webSocket.subscribe(ticker: [self.symbol])

            /*
            webSocket.subscribe(accounts: self.address)
            webSocket.subscribe(orders: self.address)
            webSocket.subscribe(transfer: self.address)
            webSocket.subscribe(trades: [self.symbol])
            webSocket.subscribe(marketDiff: [self.symbol])
            webSocket.subscribe(marketDepth: [self.symbol])
            webSocket.subscribe(candlestick: [self.symbol], interval: .oneMinute)
            webSocket.subscribe(ticker: [self.symbol])
            webSocket.subscribe(ticker: .all)
            webSocket.subscribe(miniTicker: [self.symbol])
            webSocket.subscribe(miniTicker: .all)
            webSocket.subscribe(blockheight: .all)
 */
        }

    }

    // MARK: - WebSocketDelegate

    public func webSocketDidConnect(webSocket: WebSocket) {
        self.output("websocket.didConnect", "")
    }

    public func webSocketDidDisconnect(webSocket: WebSocket) {
        self.output("websocket.didDisconnect", "")
    }

    public func webSocketDidFail(webSocket: WebSocket, with error: Error) {
        self.output("websocket.didFail", "", error)
    }

    public func webSocket(webSocket: WebSocket, orders: [Order]) {
        self.output("websocket.orders", orders)
    }
    
    public func webSocket(webSocket: WebSocket, account: Account) {
        self.output("websocket.accounts", account)
    }

    public func webSocket(webSocket: WebSocket, transfer: Transfer) {
        self.output("websocket.transfers", transfer)
    }

    public func webSocket(webSocket: WebSocket, trades: [Trade]) {
        self.output("websocket.trades", trades)
    }

    public func webSocket(webSocket: WebSocket, marketDiff: MarketDepthUpdate) {
        self.output("websocket.marketDiff", marketDiff)
    }

    public func webSocket(webSocket: WebSocket, marketDepth: MarketDepthUpdate) {
        self.output("websocket.marketDepth", marketDepth)
    }

    public func webSocket(webSocket: WebSocket, candlestick: Candlestick) {
        self.output("websocket.candlestick", candlestick)
    }

    public func webSocket(webSocket: WebSocket, ticker: [TickerStatistics]) {
        self.output("websocket.ticker", ticker)
    }

    public func webSocket(webSocket: WebSocket, miniTicker: TickerStatistics) {
        self.output("websocket.miniTicker", miniTicker)
    }

    public func webSocket(webSocket: WebSocket, miniTickers: [TickerStatistics]) {
        self.output("websocket.miniTickers", miniTickers)
    }

    public func webSocket(webSocket: WebSocket, blockHeight: Int) {
        self.output("websocket.blockHeight", blockHeight)
    }

    // MARK: - Wallet
    
    public func testWallet(endpoint: BinanceChain.Endpoint) {

        let mnemonic = "quality mind spend rigid ladder toast settle toward nature drop witness phrase"
        let key = "356f480166914051b55578f7fc7ae72f764a1f78b9e5e5a6dd2a1ae8dee2ad62"
        
        let walletAuto = Wallet(endpoint: endpoint)
        output("wallet.auto", walletAuto)
        
        let walletMnemonic = Wallet(mnemonic: mnemonic, endpoint: endpoint)
        output("wallet.mnemonic", walletMnemonic)
        
        let walletKey = Wallet(privateKey: key, endpoint: endpoint)
        output("wallet.privatekey", walletKey)

    }
    
    // MARK: - Utils

    private func output(_ label: String, _ property: Any, _ error: Error? = nil) {
        if let delegate = self.delegate { delegate.testComplete(label: label, property: property, error: error) }

        // Console
        print(String(format: "%@:", label))
        if let error = error {
            print("error: \(error.localizedDescription)\n")
            return
        }
        print(property)
        print("\n")
    }
    
}
