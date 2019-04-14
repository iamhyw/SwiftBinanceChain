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

    fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [:]
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
        let standard = StdTxMessage(message: self, wallet: self.wallet)

        // TEMP
        print(standard.amino.hexlify)
        print("\n")
        
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

    override fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "id": self.wallet.generateOrderId(),
            "ordertype": self.orderType.rawValue,
            "price": self.price,
            "quantity": self.quantity,
            "side": self.side.rawValue,
            "symbol": self.symbol,
            "timeinforce": self.timeInForce.rawValue
        ]
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

// MARK: - CancelOrderMessage

public class CancelOrderMessage: Message {

    private var symbol: String = ""
    private var orderId: String = ""

    required init(symbol: String, orderId: String, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .freeze
        self.symbol = symbol
        self.orderId = orderId
    }

    override fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "refid": self.orderId,
            "sender": self.wallet.address,
            "symbol": self.symbol
        ]
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

    internal var symbol: String = ""
    internal var amount: Int = 0

    required init(symbol: String, amount: Int, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .freeze
        self.symbol = symbol
        self.amount = amount
    }

    override fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "amount": self.amount,
            "from": self.wallet.address,
            "symbol": self.symbol
        ]
    }

    override fileprivate var protobuf: Data {
        var pb = TokenFreeze()
        pb.symbol = symbol
        pb.amount = Int64(self.amount)
        return try! pb.serializedData()
    }

}

// MARK: - UnFreezeMessage

public class UnFreezeMessage: FreezeMessage {

    required init(symbol: String, amount: Int, wallet: Wallet) {
        super.init(symbol: symbol, amount: amount, wallet: wallet)
        self.type = .unfreeze
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

    private var symbol: String = ""
    private var amount: Int = 0
    private var to: String = ""

    required init(symbol: String, amount: Int, to: String, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .transfer
        self.symbol = symbol
        self.amount = amount
        self.to = to
    }

    private func coins(symbol: String, amount: Int) -> KeyValuePairs<String, Any> {
        return  [
            "amount": amount,
            "denom": symbol
        ]
    }

    private func coins(address: String, symbol: String, amount: Int) -> KeyValuePairs<String, Any> {
        return [
            "address": address,
            "coins": self.coins(symbol: symbol, amount: amount)
        ]
    }
    
    override fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "inputs": [ coins(address: self.wallet.address, symbol: symbol, amount: amount) ],
            "outputs": [ coins(address: to, symbol: symbol, amount: amount) ]
        ]
    }

    override fileprivate var protobuf: Data {
        var token = Send.Token()
        token.denom = self.symbol
        token.amount = Int64(amount)

        var input = Send.Input()
        input.address = Segwit.decode(address: self.wallet.address)
        input.coins.append(token)
        
        var output = Send.Output()
        output.address = Segwit.decode(address: to)
        output.coins.append(token)
        
        var send = Send()
        send.inputs.append(input)
        send.outputs.append(output)
        return try! send.serializedData()
    }
    
}

// MARK: - VoteMessage

public class VoteMessage: Message {

    private var proposalId: Int = 0
    private var option: VoteOption = .no

    required init(proposalId: Int, vote option: VoteOption, wallet: Wallet) {
        super.init(wallet: wallet)
        self.type = .vote
        self.proposalId = proposalId
        self.option = option
    }

    override fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "proposal_id": Int64(self.proposalId),
            "voter": self.wallet.address,
            "option": UInt64(self.option.rawValue)
        ]
    }
    
    override fileprivate var protobuf: Data {
        var vote = Vote()
        vote.proposalID = Int64(self.proposalId)
        vote.voter = Data(self.wallet.address.utf8)
        vote.option = Int64(self.option.rawValue)
        return try! vote.serializedData()
    }
    
}

// MARK: - StdTxMessage

private class StdTxMessage: Message {
    
    var message: Message!
    var signatureMessage: SignatureMessage!
    var data: Data = Data()
    var memo: String = ""

    convenience init(message: Message, wallet: Wallet, data: Data = Data(), memo: String = "") {
        self.init(wallet: message.wallet)
        self.type = .stdTx
        self.includeLengthPrefix = true
        self.message = message
        self.data = data
        self.memo = memo
        self.signatureMessage = SignatureMessage(message: message, wallet: wallet)
    }
    
    override var protobuf: Data {
        var stdTx = StdTx()
        stdTx.msgs.append(self.message.amino)
        stdTx.signatures.append(self.signatureMessage.amino)
        stdTx.data = self.data
        stdTx.memo = self.memo
        stdTx.source = 1
        return try! stdTx.serializedData()
    }

    override var amino: Data {
        return self.protobuf
    }
    
}

// MARK: - Signature

private class Signature {
    
    private var wallet: Wallet!
    private var message: Message!
    private var chainId: String = ""
    private var data: Data?
    private var memo: String = ""

    required init(message: Message, data: Data? = nil, memo: String = "", wallet: Wallet) {
        self.message = message
        self.wallet = wallet
        self.data = data
        self.memo = memo
    }

    fileprivate var keyValuePairs: KeyValuePairs<String, Any> {
        return [
            "account_number": self.wallet.accountNumber,
            "chain_id": self.wallet.chainId,
            "data": self.data ?? Data(),
            "memo": self.memo,
            "msgs": [self.message.keyValuePairs],
            "sequence": self.wallet.sequence,
            "source": 1
        ]
    }

    var bytes: Data {

        // TEMP
        print(self.keyValuePairs.json)

        let data = Data(self.keyValuePairs.json.utf8)
        let signed = self.message.wallet.sign(message: data)
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
        let signature = Signature(message: self.message, wallet: wallet)
        var pb = StdSignature()
        pb.sequence = Int64(self.wallet.sequence)
        pb.accountNumber = Int64(self.wallet.accountNumber)
        pb.pubKey = PubKeyMessage(wallet: self.wallet).amino
        pb.signature = signature.bytes
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

// MARK: - Segwit

class Segwit {
    
    static func decode(address: String) -> Data {
        // TODO
        return Data()
    }
    
}
