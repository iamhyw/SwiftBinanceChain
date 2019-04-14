import Foundation

extension KeyValuePairs where Key == String, Value == Any {
    
    var json: String {

        // TODO:
        // This needs to return a JSON String with fields in the order they
        // were added. KeyValuePairs was used because it maintains the input
        // order, whereas Swift dicitonaries and SwiftyJSON do not. Below
        // is a fast way to generate ordered json, and will be redone
        // properly (using recursion).

        return String(format: "%@", String(describing: self))
            .replacingOccurrences(of: "[", with: "{")
            .replacingOccurrences(of: "]", with: "}")
            .replacingOccurrences(of: " bytes", with: "")
            .replacingOccurrences(of: "msgs\": {", with: "msgs\": [")
            .replacingOccurrences(of: "}, \"sequence", with: "], \"sequence")

    }
    
}
