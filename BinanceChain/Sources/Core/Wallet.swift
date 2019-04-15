import Foundation
import HDWalletKit
import CryptoSwift

public class Wallet: CustomStringConvertible {

    public var endpoint: String = BinanceChain.Endpoint.testnet.rawValue
    public var privateKey: Data { return self.key.raw }
    public var publicKey: Data { return self.key.publicKey.data }
    public var mnemonic: String = ""
    public var sequence: Int = 0
    public var accountNumber: Int = 0
    public var chainId: String = ""
    
    private var key: PrivateKey!

    required init() {
        self.initialise(mnemonic: Mnemonic.create())
    }

    convenience init(endpoint: BinanceChain.Endpoint = .testnet) {
        self.init(mnemonic: Mnemonic.create(), endpoint: endpoint.rawValue)
    }

    convenience init(endpoint: String? = nil) {
        self.init(mnemonic: Mnemonic.create(), endpoint: endpoint)
    }

    convenience init(mnemonic: String, endpoint: BinanceChain.Endpoint) {
        self.init(mnemonic: mnemonic, endpoint: endpoint.rawValue)
    }

    convenience init(mnemonic: String, endpoint: String? = nil) {
        self.init()
        if let endpoint = endpoint { self.endpoint = endpoint }
        self.initialise(mnemonic: mnemonic)
    }

    convenience init(privateKey: String, endpoint: BinanceChain.Endpoint) {
        self.init(privateKey: privateKey, endpoint: endpoint.rawValue)
    }

    convenience init(privateKey: String, endpoint: String? = nil) {
        self.init()
        if let endpoint = endpoint { self.endpoint = endpoint }
        self.key = PrivateKey(pk: privateKey, coin: .bitcoin)
        self.synchronise(completion: nil)
    }

    private func initialise(mnemonic: String, completion: Completion? = nil) {
        self.mnemonic = mnemonic
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let key = PrivateKey(seed: seed, coin: .bitcoin)
        self.key = key.bip44PrivateKey
        self.synchronise(completion: nil)
    }

    // MARK: - Wallet

    public typealias Completion = (_ error: Error?)->()

    public func synchronise(completion: Completion? = nil) {

        guard let url = URL(string: self.endpoint) else {
            if let completion = completion {
                completion(BinanceError(message: "Invalid endpoint URL"))
            }
            return
        }

        let binance = BinanceChain(endpoint: url)
        let group = DispatchGroup()
        var error: Error?

        // Update node info
        group.enter()
        binance.nodeInfo() { (response) in
            if let value = response.error {
                error = value
            } else {
                self.chainId = response.nodeInfo.network
            }
            group.leave()
        }

        // Update account sequence
        group.enter()
        binance.account(address: self.address()) { (response) in
            if let value = response.error {
                error = value
            } else {
                self.accountNumber = response.account.accountNumber
                self.sequence = response.account.sequence
            }
            group.leave()
        }

        // Synchronisation complete
        group.notify(queue: .main) {
            guard let completion = completion else { return }
            completion(error)
        }

    }

    public func generateOrderId() -> String {
        let id = String(format: "%@-%d", self.address(hrp: "").uppercased(), self.sequence)
        self.sequence += 1
        return id
    }

    @discardableResult
    public func incrementSequence() -> Int {
        self.sequence += 1
        return sequence
    }

    public func address(hrp: String? = nil) -> String {
        do {
            let hrp = hrp ?? ((self.endpoint == BinanceChain.Endpoint.testnet.rawValue) ? "tbnb" : "bnb")
            let sha = self.publicKey.sha256()
            let ripemd = RIPEMD160.hash(sha)
            let convertbits = try SegwitAddrCoder().convertBits(from: 8, to: 5, pad: false, idata: ripemd)
            let address = Bech32().encode(hrp, values: convertbits)
            return address
        } catch let error {
            print(error)
            return "InvalidKey"
        }
    }

    public func sign(message: Data) -> Data {
        do {
            let data = try self.key.sign(hash: message.sha256())
            print("Got signed data: \(data.count) bytes")
        } catch let error {
            print(error)
        }
        return message
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        return String(format: "Wallet [accountNumber=%d, sequence=%d, chain_id=%@, mnemonic=%@, address=%@, publicKey=%@, privateKey=%@, endpoint=%@]",
                      accountNumber, sequence, chainId, mnemonic, address(), publicKey.hexlify, privateKey.hexlify, endpoint)
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

