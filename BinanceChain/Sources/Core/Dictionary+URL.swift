import Foundation

extension Dictionary where Key == String, Value == Any {

    var query: String {

        let items: [URLQueryItem] = self.compactMap {
            if let value = $0.value as? String { return URLQueryItem(name: $0.key, value: String(value)) }
            if let value = $0.value as? Int { return URLQueryItem(name: $0.key, value: String(value)) }
            return nil
        }

        let url = NSURLComponents()
        url.queryItems = items
        return url.query ?? ""

    }

}

