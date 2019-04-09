import Foundation

extension String {
    
    var unhexlify: Data {
        let length = self.count / 2
        var data = Data(capacity: length)
        for i in 0 ..< length {
            let j = self.index(self.startIndex, offsetBy: i * 2)
            let k = self.index(j, offsetBy: 2)
            let bytes = self[j..<k]
            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            }
        }
        return data
    }

}
