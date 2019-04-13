import Foundation
import HDWalletKit

public class Wallet: CustomStringConvertible {

    var endpoint: String = BinanceChain.Endpoint.testnet.rawValue
    var privateKey: Data { return self.key.raw }
    var publicKey: Data { return self.key.publicKey.data }
    var address: String { return self.key.publicKey.address }
    var mnemonic: String = ""

    var sequence: Int = 0
    var accountNumber: Int = 0
    var chainId: String = ""
    
    private var key: PrivateKey!

    convenience init(endpoint: BinanceChain.Endpoint = .testnet) {
        self.init(endpoint: endpoint.rawValue)
    }

    convenience init(endpoint: String? = nil) {
        self.init(mnemonic: Mnemonic.create(), endpoint: endpoint)
    }

    convenience init(mnemonic: String, endpoint: BinanceChain.Endpoint) {
        self.init(mnemonic: mnemonic, endpoint: endpoint.rawValue)
    }

    convenience init(mnemonic: String, endpoint: String? = nil) {
        self.init()
        self.mnemonic = mnemonic
        if let endpoint = endpoint { self.endpoint = endpoint }
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let key = PrivateKey(seed: seed, coin: .bitcoin)
        self.key = key.bip44PrivateKey
    }

    convenience init(privateKey: String, endpoint: BinanceChain.Endpoint) {
        self.init(privateKey: privateKey, endpoint: endpoint.rawValue)
    }

    convenience init(privateKey: String, endpoint: String? = nil) {
        self.init()
        if let endpoint = endpoint { self.endpoint = endpoint }
        self.key = PrivateKey(pk: privateKey, coin: .bitcoin)
    }

    // MARK: - Wallet

    func sign(message: Data) -> Data {
        // TODO
        return Data()
    }
    
    // MARK: - CustomStringConvertible

    public var description: String {
        return String(format: "Wallet [mnemonic=%@, address=%@, publicKey=%@, privateKey=%@, endpoint=%@]",
                      mnemonic, address, publicKey.hexlify, privateKey.hexlify, endpoint)
    }
    
}

// MARK: - HDWalletKit

fileprivate extension HDWalletKit.PrivateKey {

    var bip44PrivateKey: PrivateKey {

        // BIP44 key derivation explained:
        // https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki

        // m/44'/714'/0'/0/0
        let bip44Purpose: UInt32 = 44
        let binanceChainCoin: UInt32 = 714
        let purpose = self.derived(at: .hardened(bip44Purpose))
        let coinType = purpose.derived(at: .hardened(binanceChainCoin))
        let account = coinType.derived(at: .hardened(0))
        let change = account.derived(at: .notHardened(0))
        let recieve = change.derived(at: .notHardened(0))
        return recieve

    }
    
}
