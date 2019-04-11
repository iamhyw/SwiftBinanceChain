import Foundation    

public enum Interval: String {
    case oneMinutes = "1m"
    case threeMinutes = "3m"
    case fiveMinutes = "5m"
    case fifteeninutes = "15m"
    case thirtyMinutes = "30m"
    case oneHour = "1h"
    case twoHours = "2h"
    case fourHours = "4h"
    case sixHours = "6h"
    case eightHours = "8h"
    case twelveHours = "12h"
    case oneDay = "1d"
    case threeDays = "3d"
    case oneWeek = "1w"
    case oneMonth = "1M"
}

public enum Limit: Int {
    case five = 5
    case ten = 10
    case twenty = 20
    case fifty = 50
    case oneHundred = 100
    case fiveHundred = 500
    case oneThousand = 1000
}

public enum Side: Int {
    case buy = 1
    case sell = 2
}

public enum Status: String {
    case acknowledge = "Ack"
    case partialFill = "PartialFill"
    case iocNoFill = "IocNoFill"
    case fullyFill = "FullyFill"
    case canceled = "Canceled"
    case expired = "Expired"
    case failedBlocking = "FailedBlocking"
    case failedMatching = "FailedMatching"
}

public enum Total: Int {
    case notRequired = 0
    case required = 1
}

public enum TxType: String {
    case newOrder = "NEW_ORDER"
    case issueToken = "ISSUE_TOKEN"
    case burnToken = "BURN_TOKEN"
    case listToken = "LIST_TOKEN"
    case cancelOrder = "CANCEL_ORDER"
    case freezeToken = "FREEZE_TOKEN"
    case unfreezeToken = "UN_FREEZE_TOKEN"
    case transfer = "TRANSFER"
    case proposal = "PROPOSAL"
    case vote = "VOTE"
    case mint = "MINT"
    case deposit = "DEPOSIT"
}

public enum TimeInForce: String {
    case goodTillExpire = "GTE"
    case immediateOrCancel = "IOC"
}

public enum TransactionSide: String {
    case receive = "RECEIVE"
    case send = "SEND"
}

public enum OrderType: String {
    case limit = "LIMIT"
    case market = "MARKET"
}

public enum FeeFor: Int {
    case proposer = 1
    case all = 2
    case free = 3
}
