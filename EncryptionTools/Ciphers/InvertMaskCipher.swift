//
//  InvertMaskCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/16/23.
//

import Foundation

struct InvertMaskCipher: Cipher {
    let mask: UInt8
    init(mask: UInt8 = 33) {
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
        let antimask = ~mask
        for index in dataBytes.indices {
            var byte = dataBytes[index]
            let maskedBits = (~byte) & mask
            byte &= antimask
            byte |= maskedBits
            dataBytes[index] = byte
        }
        return Data(dataBytes)
    }
}
