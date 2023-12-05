//
//  ReverseMaskCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/16/23.
//

import Foundation

struct ReverseMaskCipher: Cipher {
    let mask: UInt8
    init(mask: UInt8 = 175) {
        self.mask = mask
    }
    
    func encrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    private func process(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        var front = 0
        var back = dataBytes.count - 1
        let antimask = ~mask
        while front < back {
            var byteA = dataBytes[front]
            var byteB = dataBytes[back]
            let maskedA = byteA & mask
            let maskedB = byteB & mask
            byteA &= antimask
            byteB &= antimask
            byteA |= maskedB
            byteB |= maskedA
            dataBytes[front] = byteA
            dataBytes[back] = byteB
            front += 1
            back -= 1
        }
        return Data(dataBytes)
    }
}
