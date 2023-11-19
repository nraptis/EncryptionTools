//
//  WeaveMaskCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
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
//10111101 (BD) 189
//11001111 (CF) 207
//11110011 (F3) 243
//11011011 (DB) 219
//10101111 (AF) 175
//11110101 (F5) 245

struct WeaveMaskCipher: Cipher {
    let mask: UInt8
    let count: Int
    let frontStride: Int
    let backStride: Int
    init(mask: UInt8 = 170, count: Int = 1, frontStride: Int = 1, backStride: Int = 0) {
        self.mask = mask
        self.count = count
        self.frontStride = frontStride
        self.backStride = backStride
    }
    
    func encrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    private func process(data: Data) throws -> Data {
        var count = count
        if count < 1 { count = 1 }
        var dataBytes = [UInt8](data)
        var front = 0
        var back = dataBytes.count - 1
        let antimask = ~mask
        while true {
            var swaps = count
            while swaps > 0 && front < back {
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
                swaps -= 1
                front += 1
                back -= 1
            }
            if front >= back { break }
            var skips = frontStride
            while skips > 0 && front < back {
                skips -= 1
                front += 1
            }
            if front >= back { break }
            skips = backStride
            while skips > 0 && front < back {
                skips -= 1
                back -= 1
            }
            if front >= back { break }
        }
        return Data(dataBytes)
    }
}
