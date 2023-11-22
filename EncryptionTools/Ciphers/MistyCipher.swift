//
//  MistyCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/21/23.
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

//00000001 (01) 1
//00000010 (02) 2
//00000100 (04) 4
//00001000 (08) 8
//00010000 (10) 16
//00100000 (20) 32
//01000000 (40) 64
//10000000 (80) 128

//00000011 (03) 3
//00000110 (04) 4
//00001100 (06) 6
//00011000 (18) 24
//00110000 (20) 32
//01100000 (30) 48
//11000000 (C0) 192

//00000111 (07) 7
//00001110 (0E) 14
//00011100 (1C) 28
//00111000 (38) 56
//01110000 (70) 112
//11100000 (E0) 224

struct MistyCipher: Cipher {
    private func mask() -> [UInt8] {
        [0xF3, 0xDB, 0xAF, 0x08,
         0x10, 0x20, 0xC0, 0x07,
         0x20, 0xF0, 0x99, 0x0F,
         0xC3, 0x06, 0x04, 0xCF,
         0x40, 0x80, 0x03, 0x04,
         0xF5, 0x01, 0x33, 0x30,
         0xAA, 0x55, 0xBD, 0x38,
         0x70, 0xE0, 0x02, 0x1C,
         0x3C, 0xCC, 0x0E, 0x18]
    }
    
    private func noise() -> [UInt8] {
        [0x0F, 0xBD, 0xC3, 0xAF,
         0x55, 0xDB, 0xF0, 0xF5,
         0xF3, 0x33, 0x3C, 0xCF,
         0x99, 0xCC, 0xF0, 0x0F]
    }
    
    private func expandKey(dataBytes: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: dataBytes.count)
        let noiseTable = noise()
        let maskTable = mask()
        var twiddle = Int32(1773119)
        var noiseIndex: Int32 = 0
        var maskIndex = 0
        var dataIndex = 0
        while dataIndex < dataBytes.count {
            let mask = maskTable[maskIndex]
            let masked = dataBytes[dataIndex] & mask
            let noise = noiseTable[Int(noiseIndex)]
            twiddle = (twiddle + 7) * 33 ^ Int32(masked)
            twiddle = (twiddle + 11) ^ Int32(noise)
            twiddle += 13
            result[dataIndex] = UInt8(twiddle & 0xFF)
            noiseIndex += 1
            noiseIndex += Int32(masked) + (Int32(noise) << 1)
            noiseIndex |= twiddle
            noiseIndex = noiseIndex % Int32(noiseTable.count)
            twiddle = twiddle & 0xFFFFFF
            dataIndex += 1
            maskIndex += 1
            if maskIndex == maskTable.count {
                maskIndex = 0
            }
        }
        return result
    }
    
    func encrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    private func process(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        let maskTable = mask()
        let key = expandKey(dataBytes: dataBytes)
        var dataIndex = 0
        var maskIndex = 0
        while dataIndex < dataBytes.count {
            let mask = maskTable[maskIndex]
            let antimask = ~mask
            let originalMasked = data[dataIndex] & mask
            dataBytes[dataIndex] ^= key[dataIndex]
            dataBytes[dataIndex] &= antimask
            dataBytes[dataIndex] |= originalMasked
            dataIndex += 1
            maskIndex += 1
            if maskIndex == maskTable.count {
                maskIndex = 0
            }
        }
        return Data(dataBytes)
    }
}


