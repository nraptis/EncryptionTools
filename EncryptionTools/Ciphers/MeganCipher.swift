//
//  MeganCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/21/23.
//

import Foundation

struct MeganCipher: Cipher {
    private func maskTable() -> [UInt8] {
        [0xF3, 0xDB, 0xAF, 0x08,
         0x10, 0x20, 0xC0, 0x07,
         0xF5, 0x01, 0x03, 0x04,
         0xAA, 0x55, 0xBD, 0x38,
         0x20, 0xF0, 0x99, 0x0F,
         0xC3, 0x06, 0x04, 0xCF,
         0x40, 0x80, 0x33, 0x30,
         0x70, 0xE0, 0x02, 0x1C,
         0x3C, 0xCC, 0x0E, 0x18]
    }
    
    private func noiseTable() -> [UInt8] {
        [0x55, 0xDB, 0xF0, 0xF5,
         0xF3, 0x33, 0xF0, 0x0F,
         0x0E, 0x38, 0xAA, 0xAB,
         0x0F, 0xBD, 0xC3, 0xAF,
         0x99, 0xCC, 0x3C, 0xCF]
    }
    
    private let startMaskOffset: Int
    private let startNoiseOffset: Int
    init(mask: UInt8 = 224) {
        startMaskOffset = Int(mask)
        startNoiseOffset = Int(~mask)
    }
    
    private func expandKey(dataBytes: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: dataBytes.count)
        let noiseTable = noiseTable()
        let maskTable = maskTable()
        var twiddle = Int32(191523)
        var noiseIndex: Int32 = Int32(startNoiseOffset % noiseTable.count)
        if noiseIndex < 0 { noiseIndex += Int32(noiseTable.count) }
        var maskIndex = startMaskOffset % maskTable.count
        if maskIndex < 0 { maskIndex += maskTable.count }
        var dataIndex = 0
        while dataIndex < dataBytes.count {
            let mask = maskTable[maskIndex]
            let masked = dataBytes[dataIndex] & mask
            let noise = noiseTable[Int(noiseIndex)]
            twiddle = (twiddle + 71) ^ Int32(masked) ^ Int32(~noise)
            twiddle = ((twiddle << 1) ^ Int32(Int32(masked) + Int32(noise)))
            twiddle += 21
            result[dataIndex] = UInt8(twiddle & 0xFF)
            noiseIndex = (noiseIndex + twiddle + 1) % Int32(noiseTable.count)
            twiddle = twiddle & 0xFFFFFF
            dataIndex += 1
            maskIndex = (maskIndex + 1 + Int(masked)) % maskTable.count
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
        var maskIndex = startMaskOffset % maskTable.count
        if maskIndex < 0 { maskIndex += maskTable.count }
        while dataIndex < dataBytes.count {
            let mask = maskTable[maskIndex]
            let antimask = ~mask
            let originalMasked = data[dataIndex] & mask
            dataBytes[dataIndex] ^= key[dataIndex]
            dataBytes[dataIndex] &= antimask
            dataBytes[dataIndex] |= originalMasked
            dataIndex += 1
            maskIndex = (maskIndex + 1 + Int(originalMasked)) % maskTable.count
        }
        return Data(dataBytes)
    }
}
