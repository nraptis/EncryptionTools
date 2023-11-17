//
//  InvertMaskCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/16/23.
//

import Foundation

//11110000 (F0) (240)
//00001111 (0F) (15)
//11000011 (C3) (195)
//00111100 (3C) (60)
//11001100 (CC) (204)
//00110011 (33) (51)
//10011001 (99) (153)
//10101010 (AA) (170)
//01010101 (55) (85)
struct InvertMaskCrypt: Cryptable {
    let mask: UInt8
    init(mask: UInt8 = 33) {
        self.mask = mask
    }
    
    func encrypt(data: Data) throws -> Data {
        try proces(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try proces(data: data)
    }
    
    private func proces(data: Data) throws -> Data {
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
