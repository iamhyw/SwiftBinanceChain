import Foundation
import SwiftyJSON

class Parser {

    init() {
    }

    internal func parse(result: BinanceChain.Result, data: Data) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        //if let data = json as? [String:Any] { self.parse(result: result, data: data) }
        //if let data = json as? [Any] { self.parse(result: result, data: data) }
    }

    // MARK: - Parsers
    
    
    
}
