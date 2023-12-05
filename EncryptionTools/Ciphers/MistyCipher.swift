//
//  MistyCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/21/23.
//

import Foundation

struct MistyCipher: Cipher {
    private func maskTable() -> [UInt8] {
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
    
    private func noiseTable() -> [UInt8] {
        [0x0F, 0xBD, 0xC3, 0xAF,
         0x55, 0xDB, 0xF0, 0xF5,
         0xF3, 0x33, 0x3C, 0xCF,
         0x99, 0xCC, 0xF0, 0x0F]
    }
    
    private func expandKey(dataBytes: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: dataBytes.count)
        let noiseTable = noiseTable()
        let maskTable = maskTable()
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
            noiseIndex ^= Int32(masked)
            noiseIndex ^= Int32(~noise)
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
        let maskTable = maskTable()
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
