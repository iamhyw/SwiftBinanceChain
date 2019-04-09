import Foundation
import SwiftyJSON

class Parser {

    init() {
    }

    func parse(response: BinanceChain.Response, data: Data) throws {
        guard let json = try? JSON(data: data) else {
            // TODO error
            return
        }
            
        self.parse(json, response: response)
    }

    func parse(_ json: JSON, response: BinanceChain.Response) {
        // No-op
    }

    func parseTimes(_ json: JSON) -> Times {
        let times = Times()
        times.apTime = json["ap_times"].stringValue
        times.blockTime = json["block_time"].stringValue
        return times
    }
    
    func parsePeer(_ json: JSON) -> Peer {
        let peer = Peer()
        peer.id = json["id"].stringValue
        peer.listenAddr = json["listen_addr"].stringValue
        peer.originalListenAddr = json["original_listen_addr"].stringValue
        peer.accessAddr = json["access_addr"].stringValue
        peer.streamAddr = json["stream_addr"].stringValue
        peer.network = json["network"].stringValue
        peer.version = json["version"].stringValue
        peer.capabilities = json["capabilities"].map({ $0.1.stringValue })
        peer.accelerated = json["accelerated"].boolValue
        return peer
    }

    func parseToken(_ json: JSON) -> Token {
        let token = Token()
        token.name = json["name"].stringValue
        token.symbol = json["symbol"].stringValue
        token.originalSymbol = json["original_symbol"].stringValue
        token.totalSupply = json["total_supply"].stringValue
        token.owner = json["owner"].stringValue
        return token
    }
    
    func parseTrade(_ json: JSON) -> Trade {
        let trade = Trade()
        trade.baseAsset = json["baseAsset"].stringValue
        trade.blockHeight = json["blockHeight"].intValue
        trade.buyFee = json["buyFee"].stringValue
        trade.buyerId = json["buyerId"].stringValue
        trade.price = json["price"].stringValue
        trade.quantity = json["quantity"].stringValue
        trade.quoteAsset = json["quoteAsset"].stringValue
        trade.sellFee = json["sellFee"].stringValue
        trade.sellerId = json["sellerId"].stringValue
        trade.symbol = json["symbol"].stringValue
        // TODO
        //trade.time = Date(json["time"].doubleValue)
        trade.tradeId = json["tradeId"].stringValue
        return trade
    }
    
    func parseMarketDepth(_ json: JSON) -> MarketDepth {
        let marketDepth = MarketDepth()
        marketDepth.asks = json["asks"].map({ $0.1.stringValue })
        marketDepth.bids = json["bids"].map({ $0.1.stringValue })
        return marketDepth
    }
    
    func parseValidators(_ json: JSON) -> Validators {
        let validators = Validators()
        validators.blockHeight = json["block_height"].intValue
        validators.validators = json["validators"].map({ self.parseValidator($0.1) })
        return validators
    }
    
    func parseValidator(_ json: JSON) -> Validator {
        let validator = Validator()
        validator.address = json["address"].stringValue
        // TODO
        //validator.publicKey = json["pub_key"].dataValue
        validator.votingPower = json["voting_power"].intValue
        return validator
    }
    
    func parseTransactions(_ json: JSON) -> Transactions {
        let transactions = Transactions()
        transactions.total = json["total"].intValue
        transactions.tx = json["tx"].map({ self.parseTx($0.1) })
        return transactions
    }
    
    func parseTx(_ json: JSON) -> Tx {
        let tx = Tx()
        // TODO
        return tx
    }

    func parseNodeInfo(_ json: JSON) -> NodeInfo {
        let nodeInfo = NodeInfo()
        nodeInfo.id = json["id"].stringValue
        nodeInfo.listenAddr = json["listen_addr"].stringValue
        nodeInfo.network = json["network"].stringValue
        nodeInfo.version = json["version"].stringValue
        nodeInfo.channels = json["channels"].stringValue
        nodeInfo.moniker = json["moniker"].stringValue
        // TODO
        // nodeInfo.other
        // nodeInfo.syncInfo
        nodeInfo.validatorInfo = self.parseValidator(json["validator_info"])
        return nodeInfo
    }
    
    func parseMarket(_ json: JSON) -> Market {
        let market = Market()
        market.baseAssetSymbol = json["base_asset_symbol"].stringValue
        market.quoteAssetSymbol = json["quote_asset_symbol"].stringValue
        market.price = json["list_price"].stringValue
        market.tickSize = json["tick_size"].stringValue
        market.lotSize = json["lot_size"].stringValue
        // TODO
        return market
    }
    
}

class TokenParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.tokens = json.map({ self.parseToken($0.1) })
    }
}

class PeerParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.peers = json.map({ self.parsePeer($0.1) })
    }
}

class TradeParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.trades = json["trade"].map({ self.parseTrade($0.1) })
    }
}

class MarketDepthParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.marketDepth = self.parseMarketDepth(json)
    }
}

class TimesParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.times = self.parseTimes(json)
    }
}

class ValidatorsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.validators = self.parseValidators(json)
    }
}

class TransactionsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.transactions = self.parseTransactions(json)
    }
}

class NodeInfoParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.nodeInfo = self.parseNodeInfo(json["node_info"])
    }
}

class MarketsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.markets = json.map({ self.parseMarket($0.1) })
    }
}
