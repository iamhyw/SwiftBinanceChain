import Foundation

public class Times: CustomStringConvertible {
    public var apTime: Date = Date()
    public var blockTime: Date = Date()
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
    public var free: Double = 0
    public var locked: Double = 0
    public var frozen: Double = 0
}

public class Token: CustomStringConvertible {
    public var name: String = ""
    public var symbol: String = ""
    public var originalSymbol: String = ""
    public var totalSupply: Double = 0
    public var owner: String = ""
}

public class Market: CustomStringConvertible {
    public var baseAssetSymbol: String = ""
    public var quoteAssetSymbol: String = ""
    public var price: Double = 0
    public var tickSize: Double = 0
    public var lotSize: Double = 0
}

public class Fee: CustomStringConvertible {
    public var msgType: String = ""
    public var fee: String = ""
    public var feeFor: FeeFor = .all
    public var multiTransferFee: Int = 0
    public var lowerLimitAsMulti: Int = 0
    public var fixedFeeParams: FixedFeeParams?
}

public class FixedFeeParams: CustomStringConvertible {
    public var msgType: String = ""
    public var fee: String = ""
    public var feeFor: FeeFor = .all
}

public class PriceQuantity: CustomStringConvertible {
    public var price: Double = 0
    public var quantity: Double = 0
}

public class MarketDepth: CustomStringConvertible {
    public var asks: [PriceQuantity] = []
    public var bids: [PriceQuantity] = []
}

public class MarketDepthUpdate: CustomStringConvertible {
    public var symbol: String = ""
    public var depth: MarketDepth = MarketDepth()
}

public class BlockTradePage: CustomStringConvertible {
    public var total: Int = 0
    public var blockTrade: [BlockTrade] = []
}

public class BlockTrade: CustomStringConvertible {
    public var blockTime: TimeInterval = 0
    public var fee: Int = 0
    public var height: Int = 0
    public var trade: [Trade] = []
}

public class Candlestick: CustomStringConvertible {
    public var close: Double = 0
    public var closeTime: Date = Date()
    public var high: Double = 0
    public var low: Double = 0
    public var numberOfTrades: Int = 0
    public var open: Double = 0
    public var openTime: Date = Date()
    public var quoteAssetVolume: Double = 0
    public var volume: Double = 0
    public var closed: Bool = false
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
    public var price: Double = 0
    public var side: Side = .buy
    public var status: Status = .acknowledge
    public var symbol: String = ""
    public var timeInForce: TimeInForce = .immediateOrCancel
    public var tradeId: String = ""
    public var transactionHash: String = ""
    public var transactionTime: Date = Date()
    public var type: OrderType = .limit
}

public class TickerStatistics: CustomStringConvertible {
    public var askPrice: Double = 0
    public var askQuantity: Double = 0
    public var bidPrice: Double = 0
    public var bidQuantity: Double = 0
    public var closeTime: Date = Date()
    public var count: Int = 0
    public var firstId: String = ""
    public var highPrice: Double = 0
    public var lastId: String = ""
    public var lastPrice: Double = 0
    public var lastQuantity: Double = 0
    public var lowPrice: Double = 0
    public var openPrice: Double = 0
    public var openTime: Date = Date()
    public var prevClosePrice: Double = 0
    public var priceChange: Double = 0
    public var priceChangePercent: Double = 0
    public var quoteVolume: Double = 0
    public var symbol: String = ""
    public var volume: Double = 0
    public var weightedAvgPrice: Double = 0
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
    public var time: Date = Date()
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
    public var timestamp: Date = Date()
    public var toAddr: String = ""
    public var txAge: Double = 0
    public var txAsset: String = ""
    public var txFee: String = ""
    public var txHash: String = ""
    public var txType: TxType = .newOrder
    public var value: String = ""
}

public class Transfer: CustomStringConvertible {
    public var height: Int = 0
    public var transactionHash: String = ""
    public var fromAddr: String = ""
    public var transferred: [Transferred] = []
}

public class Transferred: CustomStringConvertible {
    public var toAddr: String = ""
    public var amounts: [Amount] = []
}

public class Amount: CustomStringConvertible {
    public var asset: String = ""
    public var amount: Double = 0
}

// MARK: - Messages

public class Message {

    enum MessageType: String {
        case transfer = "2A2C87FA"
        case newOrder = "CE6DC043"
        case cancelOrder = "166E681B"
        case freeze = "E774B32D"
        case unfreeze = "6515FF0D"
        case signature = ""
        case pubKey = "EB5AE987"
        var data: Data { return self.rawValue.unhexlify }
    }

    fileprivate var type: MessageType = .newOrder
    fileprivate var includeLengthPrefix: Bool = false

    var protobuf: Data {
        return Data()
    }

    var bytes: Data {
        let protobuf = self.protobuf
        var data = Data()
        if (includeLengthPrefix) {
            let length: Int = Varint.encodedSize(of: Int32(type.data.count + protobuf.count))
            print("  VARINT of: \(type.data.count + protobuf.count)")
            print("  VARINT length: \(length)")
            data.append(UInt8(length))
        }
        data += type.data
        data += protobuf
        print("  TYPE length: \(type.data.count)")
        print("  PROTOBUF length: \(protobuf.count)")
        print("  DATA length: \(data.count)")
        return data
    }

    func sign(with wallet: Wallet) -> Data {

        return self.bytes
        
    }

}

class NewOrderMessage: Message {

    private var symbol: String = ""
    private var orderType: OrderType = .limit
    private var side: Side = .buy
    private var price: Double = 0
    private var quantity: Double = 0
    private var timeInForce: TimeInForce = .goodTillExpire

    required init(symbol: String, orderType: OrderType, side: Side, price: Double, quantity: Double, timeInForce: TimeInForce) {
        super.init()
        self.symbol = symbol
        self.type = .newOrder
        self.orderType = orderType
        self.side = side
        self.price = price
        self.quantity = quantity
        self.timeInForce = timeInForce
        self.symbol = symbol
    }

    override var protobuf: Data {
        var pb = NewOrder()
        pb.symbol = symbol
        pb.ordertype = Int64(self.orderType.rawValue)
        pb.side = Int64(self.side.rawValue)
        pb.price = Int64(price)
        pb.quantity = Int64(quantity)
        pb.timeinforce = Int64(self.timeInForce.rawValue)
        return try! pb.serializedData()
    }

}

class CancelMessage: Message {

    private var symbol: String = ""
    private var orderId: String = ""

    required init(symbol: String, orderId: String) {
        super.init()
        self.type = .freeze
        self.symbol = symbol
        self.orderId = orderId
    }

    override var protobuf: Data {
        var pb = CancelOrder()
        pb.symbol = symbol
        pb.refid = self.orderId
        return try! pb.serializedData()
    }

}

class FreezeMessage: Message {

    private var symbol: String = ""
    private var amount: Int = 0

    required init(symbol: String, amount: Int) {
        super.init()
        self.type = .freeze
        self.symbol = symbol
        self.amount = amount
    }

    override var protobuf: Data {
        var pb = TokenFreeze()
        pb.symbol = symbol
        pb.amount = Int64(self.amount)
        return try! pb.serializedData()
    }

}

class UnFreezeMessage: Message {

    private var symbol: String = ""
    private var amount: Int = 0

    required init(symbol: String, amount: Int) {
        super.init()
        self.type = .unfreeze
        self.symbol = symbol
        self.amount = amount
    }

    override var protobuf: Data {
        var pb = TokenUnfreeze()
        pb.symbol = symbol
        pb.amount = Int64(self.amount)
        return try! pb.serializedData()
    }
    
}

class TransferMessage: Message {

    private struct Token {
        var address: String = ""
        var amount: Int = 0
    }

    required init(fromAddress: String, fromDenom: String, fromAmount: Int, toAddress: String, toDenom: String, toAmount: Int) {
        super.init()
        self.type = .transfer
    }

    override var protobuf: Data {
        var pb = Send()
        pb.inputs = []
        pb.outputs = []
        // TODO
        return try! pb.serializedData()
    }
    
}

class SignatureMessage: Message {

    private var publicKey: PubKeyMessage!
    private var signature: Data = Data()
    private var accountNumber: Int = 0
    private var sequence: Int = 0

    required init(publicKey: PubKeyMessage, signature: Data, accountNumber: Int, sequence: Int) {
        super.init()
        self.type = .signature
        self.signature = signature
        self.publicKey = publicKey
        self.accountNumber = accountNumber
        self.sequence = sequence
    }

    override var protobuf: Data {
        var pb = StdSignature()
        pb.pubKey = self.publicKey.bytes
        pb.accountNumber = Int64(accountNumber)
        pb.sequence = Int64(sequence)
        return try! pb.serializedData()
    }

}

class PubKeyMessage: Message {
    
    private var data: Data = Data()

    required init(data: Data) {
        super.init()
        self.type = .pubKey
        self.data = data
    }

    override var protobuf: Data {
        return self.data
    }
    
    override var bytes: Data {
        let protobuf = self.protobuf
        let varint = Varint.encodedSize(of: UInt32(protobuf.count))
        var data = Data()
        data.append(type.data)
        data.append(UInt8(varint))
        data.append(protobuf)
        return data
    }
    
}
