import Foundation

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
