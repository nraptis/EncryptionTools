//
//  Data+Hex.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

extension Data {
    init(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        var index = hexString.startIndex
        for _ in 0..<length {
            let bytes = hexString[index..<hexString.index(index, offsetBy: 2)]
            if var number = UInt8(bytes, radix: 16) {
                data.append(&number, count: 1)
            } else {
                print(hexString)
                fatalError("Bad Hex String!")
            }
            index = hexString.index(index, offsetBy: 2)
        }
        self = data
    }
    
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}

