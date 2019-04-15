import Foundation
import SwiftProtobuf

public class Message {

    private enum MessageType: String {
        case newOrder = "CE6DC043"
        case cancelOrder = "166E681B"
        case freeze = "E774B32D"
        case unfreeze = "6515FF0D"
        case transfer = "2A2C87FA"
        case vote = "A1CADD36"
        case stdtx = "F0625DEE"
        case signature = ""
        case publicKey = "EB5AE987"
    }

    private enum Source: Int {
        case hidden = 0
        case broadcast = 1
    }

    private var type: MessageType = .newOrder
    private var wallet: Wallet
    private var symbol: String = ""
    private var orderId: String = ""
    private var orderType: OrderType = .limit
    private var side: Side = .buy
    private var price: Double = 0
    private var amount: Double = 0
    private var quantity: Double = 0
    private var timeInForce: TimeInForce = .goodTillExpire
    private var data: Data = Data()
    private var memo: String = ""
    private var toAddress: String = ""
    private var proposalId: Int = 0
    private var voteOption: VoteOption = .no
    private var source: Source = .broadcast

    // MARK: - Constructors

    private init(type: MessageType, wallet: Wallet) {
        self.type = type
        self.wallet = wallet
    }

    public static func newOrder(symbol: String, orderType: OrderType, side: Side, price: Double, quantity: Double, timeInForce: TimeInForce, wallet: Wallet) -> Message {
        let message = Message(type: .newOrder, wallet: wallet)
        message.symbol = symbol
        message.orderType = orderType
        message.side = side
        message.price = price
        message.quantity = quantity
        message.timeInForce = timeInForce
        message.orderId = wallet.generateOrderId()
        return message
    }

    public static func cancelOrder(symbol: String, orderId: String, wallet: Wallet) -> Message {
        let message = Message(type: .cancelOrder, wallet: wallet)
        message.symbol = symbol
        message.orderId = orderId
        return message
    }

    public static func freeze(symbol: String, amount: Double, wallet: Wallet) -> Message  {
        let message = Message(type: .freeze, wallet: wallet)
        message.symbol = symbol
        message.amount = amount
        return message
    }

    public static func unfreeze(symbol: String, amount: Double, wallet: Wallet) -> Message  {
        let message = Message(type: .unfreeze, wallet: wallet)
        message.symbol = symbol
        message.amount = amount
        return message
    }

    public static func transfer(symbol: String, amount: Double, to address: String, wallet: Wallet) -> Message {
        let message = Message(type: .transfer, wallet: wallet)
        message.symbol = symbol
        message.amount = amount
        message.toAddress = address
        return message
    }

    public static func vote(proposalId: Int, vote option: VoteOption, wallet: Wallet) -> Message {
        let message = Message(type: .cancelOrder, wallet: wallet)
        message.proposalId = proposalId
        message.voteOption = option
        return message
    }

    // MARK: - Public

    public func encode() throws -> Data {

        print("Address  : ", self.wallet.address())
        
        // Generate encoded message
        var message = Data()
        let body = try self.body(type: self.type)
        message.append(body.varint)
        message.append(self.type.rawValue.unhexlify)
        message.append(body)
        print("Message  : ", message.hexlify)

        // Generate signature
        let signature = try self.body(type: .signature)
        print("Signature: ", signature.hexlify)
        
        // Wrap in StdTx structure
        var stdtx = StdTx()
        stdtx.msgs.append(message)
        stdtx.signatures.append(signature)
        stdtx.memo = self.memo
        stdtx.source = Int64(Source.broadcast.rawValue)
        stdtx.data = Data()
        print("StdTd    : ", try stdtx.serializedData().hexlify)
        
        // Prefix length and stdtx type
        var content = Data()
        content.append(MessageType.stdtx.rawValue.unhexlify)
        content.append(try stdtx.serializedData())
        print("StdTd Len: ", content.hexlify)

        // Complete Standard Transaction
        var transaction = Data()
        transaction.append(content.varint)
        transaction.append(content)
        print("Trans    : ", transaction.hexlify)
        return transaction

    }
    
    // MARK: - Private

    private func body(type: MessageType) throws -> Data {

        switch (type) {

        case .newOrder:
            var pb = NewOrder()
            pb.sender = Data(self.wallet.address().utf8)
            pb.id = self.orderId
            pb.symbol = symbol
            pb.timeinforce = Int64(self.timeInForce.rawValue)
            pb.ordertype = Int64(self.orderType.rawValue)
            pb.side = Int64(self.side.rawValue)
            pb.price = Int64(price)
            pb.quantity = Int64(quantity)
            return try pb.serializedData()

        case .cancelOrder:
            var pb = CancelOrder()
            pb.symbol = self.symbol
            pb.refid = self.orderId
            return try pb.serializedData()

        case .freeze:
            var pb = TokenFreeze()
            pb.symbol = symbol
            pb.amount = Int64(self.amount)
            return try pb.serializedData()

        case .unfreeze:
            var pb = TokenUnfreeze()
            pb.symbol = symbol
            pb.amount = Int64(self.amount)
            return try pb.serializedData()

        case .transfer:
            var token = Send.Token()
            token.denom = self.symbol
            token.amount = Int64(amount)

            var input = Send.Input()
            input.address = Data(self.wallet.address().utf8)
            input.coins.append(token)

            var output = Send.Output()
            //output.address = Segwit.decode(address: to)
            output.coins.append(token)
            
            var send = Send()
            send.inputs.append(input)
            send.outputs.append(output)
            return try send.serializedData()

        case .signature:
            var pb = StdSignature()
            pb.sequence = Int64(self.wallet.sequence)
            pb.accountNumber = Int64(self.wallet.accountNumber)
            pb.pubKey = try self.body(type: .publicKey)
            pb.signature = self.signature()
            return try pb.serializedData()

        case .publicKey:
            let key = self.wallet.publicKey
            var data = Data()
            data.append(type.rawValue.unhexlify)
            data.append(key.varint)
            data.append(key)
            return data

        case .vote:
            var vote = Vote()
            vote.proposalID = Int64(self.proposalId)
            vote.voter = Data(self.wallet.address().utf8)
            vote.option = Int64(self.voteOption.rawValue)
            return try vote.serializedData()
            
        default:
            throw BinanceError(message: "Invalid type")

        }

    }

    private func signature() -> Data {
        print("\n")
        print(self.json)
        print("\n")
        let data = Data(self.json.utf8)
        return self.wallet.sign(message: data)
    }

    private var json: String {

        switch (self.type) {

        case .newOrder:
            return String(format: JSON.newOrder,
                          self.orderId,
                          self.orderType.rawValue,
                          self.price,
                          self.quantity,
                          self.wallet.address(),
                          self.side.rawValue,
                          self.symbol,
                          self.timeInForce.rawValue)

        case .cancelOrder:
            return String(format: JSON.cancelOrder,
                          self.orderId,
                          self.wallet.address(),
                          self.symbol)

        case .freeze:
            return String(format: JSON.freeze,
                          self.amount,
                          self.wallet.address(),
                          self.symbol)

        case .unfreeze:
            return String(format: JSON.unfreeze,
                          self.amount,
                          self.wallet.address(),
                          self.symbol)

        case .transfer:
            return String(format: JSON.transfer,
                          self.wallet.accountNumber,
                          self.wallet.chainId,
                          self.memo,
                          self.wallet.address(),
                          self.symbol,
                          self.amount,
                          self.toAddress,
                          self.symbol,
                          self.amount,
                          self.wallet.sequence,
                          self.source.rawValue)

        case .vote:
            return String(format: JSON.vote,
                          self.wallet.address(),
                          self.voteOption.rawValue)

        default:
            return "{}"
            
        }
        
    }

}

fileprivate extension Data {
    var varint: UInt8 {
        return UInt8(Varint.encodedSize(of: UInt32(self.count)))
    }
}

fileprivate class JSON {

    // Signing requires a strictly ordered JSON string. Neither swift nor
    // SwiftyJSON maintain the order, so instead we use strings.

    static let newOrder = """
{
   "id" : "%@",
   "order_type" : "%d",
   "price" : "%f",
   "quantity" : "%f",
   "sender" : "%@",
   "side" : "%d",
   "symbol" : "%@",
   "timeinforce" : "%d"
}
"""

    static let cancelOrder = """
{
   "refid" : "%@",
   "sender": "%@",
   "symbol" : "%@"
}
"""

    static let freeze = """
{
   "amount" : "%f",
   "from" : "%@",
   "symbol" : "%@"
}
"""

    static let unfreeze = """
{
   "amount" : "%f",
   "from" : "%@",
   "symbol" : "%@"
}
"""

    static let transfer = """
{
   "account_number" : "%d",
   "data" : null,
   "chain_id" : "%@",
   "memo" : "%@",
   "msgs" : [
      {
         "inputs" : [
            {
               "address" : "%@",
               "coins" : [
                  {
                     "denom" : "%@",
                     "amount" : "%f"
                  }
               ]
            }
         ],
         "outputs" : [
            {
               "address" : "%@",
               "coins" : [
                  {
                     "denom" : "%@",
                     "amount" : "%f"
                  }
               ]
            }
         ]
      }
   ],
   "sequence" : "%d",
   "source" : "%d"
}
"""

    static let vote = """
{
    "voter": "%@",
    "option": "%d"
}
"""
    
}
