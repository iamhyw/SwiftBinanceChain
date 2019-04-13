import Foundation

// MARK: - Message

public class Message {

    enum MessageType: String {
        case transfer = "2A2C87FA"
        case newOrder = "CE6DC043"
        case cancelOrder = "166E681B"
        case freeze = "E774B32D"
        case unfreeze = "6515FF0D"
        case stdTx = "0xF0625DEE"
        case signature = ""
        case pubKey = "EB5AE987"
        case vote = "A1CADD36"
        var data: Data { return self.rawValue.unhexlify }
    }

    fileprivate var type: MessageType = .newOrder
    fileprivate var includeLengthPrefix: Bool = false

    var wallet: Wallet!

    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    fileprivate var protobuf: Data {
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

    var bytes: Data {
        let standard = StdTxMessage(message: self)
        return standard.amino
    }
    
}

// MARK: - NewOrderMessage

public class NewOrderMessage: Message {

    private var symbol: String = ""
    private var orderType: OrderType = .limit
    private var side: Side = .buy
    private var price: Double = 0
    private var quantity: Double = 0
    private var timeInForce: TimeInForce = .goodTillExpire

    required init(symbol: String, orderType: OrderType, side: Side, price: Double, quantity: Double, timeInForce: TimeInForce, wallet: Wallet) {
        super.init(wallet: wallet)
        self.symbol = symbol
        self.type = .newOrder
        self.orderType = orderType
        self.side = side
        self.price = price
        self.quantity = quantity
        self.timeInForce = timeInForce
        self.symbol = symbol
    }

    override fileprivate var protobuf: Data {
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

// MARK: - CancelMessage

public class CancelMessage: Message {

    private var symbol: String = ""
    private var orderId: String = ""

    required init(symbol: String, orderId: String, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .freeze
        self.symbol = symbol
        self.orderId = orderId
    }

    override fileprivate var protobuf: Data {
        var pb = CancelOrder()
        pb.symbol = symbol
        pb.refid = self.orderId
        return try! pb.serializedData()
    }

}

// MARK: - FreezeMessage

public class FreezeMessage: Message {

    private var symbol: String = ""
    private var amount: Int = 0

    required init(symbol: String, amount: Int, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .freeze
        self.symbol = symbol
        self.amount = amount
    }

    override fileprivate var protobuf: Data {
        var pb = TokenFreeze()
        pb.symbol = symbol
        pb.amount = Int64(self.amount)
        return try! pb.serializedData()
    }

}

// MARK: - UnFreezeMessage

public class UnFreezeMessage: Message {

    private var symbol: String = ""
    private var amount: Int = 0

    required init(symbol: String, amount: Int, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .unfreeze
        self.symbol = symbol
        self.amount = amount
    }

    override fileprivate var protobuf: Data {
        var pb = TokenUnfreeze()
        pb.symbol = symbol
        pb.amount = Int64(self.amount)
        return try! pb.serializedData()
    }
    
}

// MARK: - TransferMessage

public class TransferMessage: Message {

    private struct Token {
        var address: String = ""
        var amount: Int = 0
    }

    required init(from: String, fromDenom: String, fromAmount: Int, to: String, toDenom: String, toAmount: Int, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .transfer
    }

    override fileprivate var protobuf: Data {
        var pb = Send()
        pb.inputs = []
        pb.outputs = []
        // TODO
        return try! pb.serializedData()
    }
    
}

// MARK: - VoteMessage

public class VoteMessage: Message {

    private var proposalId: Int = 0
    private var address: String = ""
    private var vote: VoteOption = .no

    required init(proposalId: Int, vote: VoteOption, address: String, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .vote
        self.proposalId = proposalId
        self.address = address
        self.vote = vote
    }

    override fileprivate var protobuf: Data {
        var vote = Vote()
        vote.proposalID = Int64(self.proposalId)
        vote.voter = Data(address.utf8)
        vote.option = Int64(self.vote.rawValue)
        return try! vote.serializedData()
    }
    
}

// MARK: - StdTxMessage

private class StdTxMessage: Message {
    
    var message: Message!
    var signature: SignatureMessage!
    
    convenience init(message: Message) {
        self.init(wallet: message.wallet)
        self.type = .stdTx
        self.includeLengthPrefix = true
        self.message = message
        self.signature = SignatureMessage(message: message, wallet: wallet)
    }
    
    override var bytes: Data {
        var stdTx = StdTx()
        stdTx.msgs.append(self.message.amino)
        stdTx.signatures.append(self.signature.amino)
        stdTx.msgs = [self.message.bytes]
        stdTx.source = 1
        return try! stdTx.serializedData()
    }
    
}

// MARK: - Signature

private class Signature {
    
    private var message: Message!
    private var chainId: String = ""
    private var data: Data?
    private var memo: String = ""

    required init(message: Message, data: Data? = nil, memo: String = "") {
        self.message = message
        self.data = data
        self.memo = memo
    }

    var bytes: Data {
        // JSON
        // to bytes
        return Data()
    }

    var signedBytes: Data {
        let signed = self.message.wallet.sign(message: self.bytes)
        return signed.suffix(64)
    }
    
}

// MARK: - SignatureMessage

private class SignatureMessage: Message {

    private var message: Message!

    required init(message: Message, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .signature
        self.message = message
    }

    override fileprivate var protobuf: Data {
        let signature = Signature(message: self.message)
        var pb = StdSignature()
        pb.sequence = Int64(self.wallet.sequence)
        pb.accountNumber = Int64(self.wallet.accountNumber)
        pb.pubKey = PubKeyMessage(wallet: self.wallet).amino
        pb.signature = signature.signedBytes
        return try! pb.serializedData()
    }

}

// MARK: - PubKeyMessage

private class PubKeyMessage: Message {

    override init(wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .pubKey
    }

    override fileprivate var protobuf: Data {
        return self.wallet.publicKey
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
