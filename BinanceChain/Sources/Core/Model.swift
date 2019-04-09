import Foundation

class Error {
    var code: Int = 0
    var message: String = ""
}

class Times {
    var apTime: String = ""
    var blockTime: String = ""
}

class Validator {
    var blockHeight: Int = 0
    var validators: [Any] = []
}

class Peer {
    var id: String = ""
    var originalListenAddr: String = ""
    var listenAddr: String = ""
    var accessAddr: String = ""
    var streamAddr: String = ""
    var network: String = ""
    var version: String = ""
    var moniker: String = ""
    var capabilities: [String] = []
    var accelerated: Bool = false
}

class Transaction {
    var hash: String = ""
    var log: String = ""
    var data: String = ""
    var tx: Data = Data()
}

class Account {
    var accountNumber: Int = 0
    var address: String = ""
    var balances: [Balance] = []
    var publicKey: Data = Data()
    var sequence: Int = 0
}

class AccountSequence {
    var sequence: Int = 0
}

class Balance {
    var symbol: String = ""
    var free: String = ""
    var locked: String = ""
    var frozen: String = ""
}

class Token {
    var name: String = ""
    var symbol: String = ""
    var originalSymbol: String = ""
    var totalSupply: String = ""
    var owner: String = ""
}

class Market {
    var baseAssetSymbol: String = ""
    var quoteAssetSymbol: String = ""
    var price: String = ""
    var tickSize: String = ""
    var lotSize: String = ""
}

class Fee {
    var msgType: String = ""
    var fee: Int = 0
    var feeFor: Int = 0
    var multiTransferFee: String = ""
    var lowerLimitAsMulti: String = ""
    var fixedFeeParams: FixedFeeParams?
}

class FixedFeeParams {
    var msgType: String = ""
    var fee: Int = 0
    var feeFor: Int = 0
}

class MarketDepth {
    var asks: [String] = []
    var bids: [String] = []
}

class BlockTradePage {
    var total: Int = 0
    var blockTrade: [BlockTrade] = []
}

class BlockTrade {
    var blockTime: TimeInterval = 0
    var fee: String = ""
    var height: Int = 0
    var trade: [Trade] = []
}

class Candlestick {
    var close: Double = 0
    var closeTime: Int = 0
    var high: Double = 0
    var low: Double = 0
    var numberOfTrades: Int = 0
    var open: Double = 0
    var openTime: TimeInterval = 0
    var quoteAssetVolume: Double = 0
    var volume: Double = 0
}

class OrderList {
    var total: Int = 0
    var order: [Order] = []
}

class Order {
    var cumulateQuantity: String = ""
    var fee: String = ""
    var lastExecutedPrice: String = ""
    var lastExecuteQuantity: String = ""
    var orderCreateTime: Date = Date()
    var orderId: String = ""
    var owner: String = ""
    var price: String = ""
    var status: String = ""
    var symbol: String = ""
    var timeInForce: Int = 0
    var tradeId: String = ""
    var transactionHash: String = ""
    var transactionTime: Date = Date()
    var type: Int = 0
}

class TickerStatistics {
    var askPrice: String = ""
    var askQuantity: String = ""
    var bidPrice: String = ""
    var bidQuantity: String = ""
    var closeTime: TimeInterval = 0
    var count: Int = 0
    var firstId: String = ""
    var highPrice: String = ""
    var lastId: String = ""
    var lastPrice: String = ""
    var lastQuantity: String = ""
    var lowPrice: String = ""
    var openPrice: String = ""
    var openTime: TimeInterval = 0
    var prevClosePrice: String = ""
    var priceChange: String = ""
    var priceChangePercent: String = ""
    var quoteVolume: String = ""
    var symbol: String = ""
    var volume: String = ""
    var weightedAvgPrice: String = ""
}

class TradePage {
    var total: Int = 0
    var trade: [Trade] = []
}

class Trade {
    var baseAsset: String = ""
    var blockHeight: Int = 0
    var buyFee: String = ""
    var buyerId: String = ""
    var buyerOrderId: String = ""
    var price: String = ""
    var quantity: String = ""
    var quoteAsset: String = ""
    var sellFee: String = ""
    var sellerId: String = ""
    var symbol: String = ""
    var time: TimeInterval = 0
    var tradeId: String = ""
}

class TxPage {
    var total: Int = 0
    var tx: [Tx] = []
}

class Tx {
    var blockHeight: Double = 0
    var code: Int = 0
    var confirmBlocks: Double = 0
    var data: String = ""
    var fromAddr: String = ""
    var orderId: String = ""
    var timeStamp: Date = Date()
    var toAddr: String = ""
    var txAge: Double = 0
    var txAsset: String = ""
    var txFee: String = ""
    var txHash: String = ""
    var txType: String = ""
    var value: String = ""
}

class ExchangeRate {
    
}

// MARK: - Messages

class Message {

    enum MessageType: String {
        case none = ""
        case newOrder = "CE6DC043"
        case cancelOrder = "166E681B"
        case freeze = "E774B32D"
        case unfreeze = "6515FF0D"
        case signature = "TODO"
        case stdTx = "F0625DEE"
        case pubKey = "EB5AE987"
        var data: Data { return self.rawValue.unhexlify }
    }

    var type: MessageType = .newOrder
    var includeLengthPrefix: Bool = false

    var protobuf: Data {
        return Data()
    }

    var amino: Data {
        let protobuf = self.protobuf
        var data = Data()
        if (includeLengthPrefix) {
            let length: Int = Varint.encodedSize(of: Int32(type.data.count + protobuf.count))
            data.append(UInt8(length))
        }
        data += type.data
        data += protobuf
        return data
    }
    
}

class NewOrderMessage: Message {

    var symbol: String = ""

    required init(symbol: String) {
        super.init()
        self.type = .newOrder
        self.symbol = symbol
    }

    override var protobuf: Data {
        var pb = NewOrder()
        pb.symbol = symbol
        return try! pb.serializedData()
    }
    
}

class FreezeMessage: Message {
    
    override init() {
        super.init()
        self.type = .freeze
    }
    
}

class UnFreezeMessage: Message {
    
    override init() {
        super.init()
        self.type = .unfreeze
    }
    
}

class SignatureMessage: Message {
    
    override init() {
        super.init()
        self.type = .signature
    }
    
}

class StdTxMessage: Message {
    
    override init() {
        super.init()
        self.type = .stdTx
        self.includeLengthPrefix = true
    }
    
}

class PubKeyMessage: Message {
    
    override init() {
        super.init()
        self.type = .pubKey
    }
    
    override var amino: Data {
        let protobuf = self.protobuf
        let varint = Varint.encodedSize(of: UInt32(protobuf.count))
        var data = Data()
        data.append(type.data)
        data.append(UInt8(varint))
        data.append(protobuf)
        return data
    }
    
}
