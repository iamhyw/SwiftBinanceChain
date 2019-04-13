import Foundation
import HDWalletKit

public class Wallet: CustomStringConvertible {

    var endpoint: String = BinanceChain.Endpoint.testnet.rawValue
    var address: String = ""
    var mnemonic: String = ""
    var privateKey: Data = Data()
    var publicKey: Data = Data()
    var publicKeyHex: String { return self.privateKey.hexlify }

    convenience init(endpoint: BinanceChain.Endpoint) {
        self.init(endpoint: endpoint.rawValue)
    }

    convenience init(endpoint: String? = nil) {
        self.init(mnemonic: Mnemonic.create(), endpoint: endpoint)
    }

    required init(mnemonic: String, endpoint: String? = nil) {
        self.mnemonic = mnemonic
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = HDWalletKit.Wallet(seed: seed, network: .main(.bitcoin))
        let account = wallet.generateAccount(at: 0)
        self.address = account.address
        self.privateKey = account.privateKey.raw
        self.publicKey = account.privateKey.publicKey.raw
    }

}
