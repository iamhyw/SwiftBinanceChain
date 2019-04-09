import Foundation
import secp256k1
//import mnemonic

class Wallet {

    var privateKey: Data = Data()
    var publicKey: Data = Data()
    var address: String = ""
    var publicKeyHex: String { return self.privateKey.hexlify }

    init(privateKey: Data) {
        
    }

    init(mnemonic: String) {

    }
    
}
