import Foundation

public class Times: CustomStringConvertible {
    public var apTime: String = ""
    public var blockTime: String = ""
}

public class Validators: CustomStringConvertible {
    public var blockHeight: Int = 0
    public var validators: [Validator] = []
}

public class Validator: CustomStringConvertible {
    public var address: String = ""
    public var publicKey: Data = Data()
    public var votingPower: Int = 0
}

public class Peer: CustomStringConvertible {
    public var id: String = ""
    public var originalListenAddr: String = ""
    public var listenAddr: String = ""
    public var accessAddr: String = ""
    public var streamAddr: String = ""
    public var network: String = ""
    public var version: String = ""
    public var moniker: String = ""
    public var capabilities: [String] = []
    public var accelerated: Bool = false
}

public class NodeInfo: CustomStringConvertible {
    public var id: String = ""
    public var listenAddr: String = ""
    public var network: String = ""
    public var version: String = ""
    public var moniker: String = ""
    public var address: String = ""
    public var channels: String = ""
    public var other: [String:String] = [:]
    public var syncInfo: [String:String] = [:]
    public var validatorInfo: Validator = Validator()
}

public class Transactions: CustomStringConvertible {
    public var total: Int = 0
    public var tx: [Tx] = []
}

public class Transaction: CustomStringConvertible {
    public var hash: String = ""
    public var log: String = ""
    public var data: String = ""
    public var tx: Data = Data()
}

public class Account: CustomStringConvertible {
    public var accountNumber: Int = 0
    public var address: String = ""
    public var balances: [Balance] = []
    public var publicKey: Data = Data()
    public var sequence: Int = 0
}

public class AccountSequence: CustomStringConvertible {
    public var sequence: Int = 0
}

public class Balance: CustomStringConvertible {
    public var symbol: String = ""
    public var free: String = ""
    public var locked: String = ""
    public var frozen: String = ""
}

public class Token: CustomStringConvertible {
    public var name: String = ""
    public var symbol: String = ""
    public var originalSymbol: String = ""
    public var totalSupply: String = ""
    public var owner: String = ""
}

public class Market: CustomStringConvertible {
    public var baseAssetSymbol: String = ""
    public var quoteAssetSymbol: String = ""
    public var price: String = ""
    public var tickSize: String = ""
    public var lotSize: String = ""
}

public class Fee: CustomStringConvertible {
    public var msgType: String = ""
    public var fee: Int = 0
    public var feeFor: Int = 0
    public var multiTransferFee: String = ""
    public var lowerLimitAsMulti: String = ""
    public var fixedFeeParams: FixedFeeParams?
}

public class FixedFeeParams: CustomStringConvertible {
    public var msgType: String = ""
    public var fee: Int = 0
    public var feeFor: Int = 0
}

public class PriceQuantity: CustomStringConvertible {
    public var price: String = ""
    public var quantity: String = ""
}

public class MarketDepth: CustomStringConvertible {
    public var asks: [PriceQuantity] = []
    public var bids: [PriceQuantity] = []
}

public class BlockTradePage: CustomStringConvertible {
    public var total: Int = 0
    public var blockTrade: [BlockTrade] = []
}

public class BlockTrade: CustomStringConvertible {
    public var blockTime: TimeInterval = 0
    public var fee: String = ""
    public var height: Int = 0
    public var trade: [Trade] = []
}

public class Candlestick: CustomStringConvertible {
    public var close: Int = 0
    public var closeTime: String = ""
    public var high: String = ""
    public var low: String = ""
    public var numberOfTrades: String = ""
    public var open: String = ""
    public var openTime: TimeInterval = 0
    public var quoteAssetVolume: String = ""
    public var volume: Int = 0
}

public class OrderList: CustomStringConvertible {
    public var total: Int = 0
    public var orders: [Order] = []
}

public class Order: CustomStringConvertible {
    public var cumulateQuantity: String = ""
    public var fee: String = ""
    public var lastExecutedPrice: String = ""
    public var lastExecuteQuantity: String = ""
    public var orderCreateTime: Date = Date()
    public var orderId: String = ""
    public var owner: String = ""
    public var price: String = ""
    public var status: String = ""
    public var symbol: String = ""
    public var timeInForce: Int = 0
    public var tradeId: String = ""
    public var transactionHash: String = ""
    public var transactionTime: Date = Date()
    public var type: Int = 0
}

public class TickerStatistics: CustomStringConvertible {
    public var askPrice: String = ""
    public var askQuantity: String = ""
    public var bidPrice: String = ""
    public var bidQuantity: String = ""
    public var closeTime: TimeInterval = 0
    public var count: Int = 0
    public var firstId: String = ""
    public var highPrice: String = ""
    public var lastId: String = ""
    public var lastPrice: String = ""
    public var lastQuantity: String = ""
    public var lowPrice: String = ""
    public var openPrice: String = ""
    public var openTime: TimeInterval = 0
    public var prevClosePrice: String = ""
    public var priceChange: String = ""
    public var priceChangePercent: String = ""
    public var quoteVolume: String = ""
    public var symbol: String = ""
    public var volume: String = ""
    public var weightedAvgPrice: String = ""
}

public class TradePage: CustomStringConvertible {
    public var total: Int = 0
    public var trade: [Trade] = []
}

public class Trade: CustomStringConvertible {
    public var baseAsset: String = ""
    public var blockHeight: Int = 0
    public var buyFee: String = ""
    public var buyerId: String = ""
    public var buyerOrderId: String = ""
    public var price: String = ""
    public var quantity: String = ""
    public var quoteAsset: String = ""
    public var sellFee: String = ""
    public var sellerId: String = ""
    public var symbol: String = ""
    public var time: TimeInterval = 0
    public var tradeId: String = ""
}

public class TxPage: CustomStringConvertible {
    public var total: Int = 0
    public var tx: [Tx] = []
}

public class Tx: CustomStringConvertible {
    public var blockHeight: Double = 0
    public var code: Int = 0
    public var confirmBlocks: Double = 0
    public var data: String = ""
    public var fromAddr: String = ""
    public var orderId: String = ""
    public var timeStamp: Date = Date()
    public var toAddr: String = ""
    public var txAge: Double = 0
    public var txAsset: String = ""
    public var txFee: String = ""
    public var txHash: String = ""
    public var txType: String = ""
    public var value: String = ""
}

public class ExchangeRate: CustomStringConvertible {
    
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
