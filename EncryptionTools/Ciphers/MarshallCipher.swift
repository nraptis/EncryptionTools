//
//  MarshallCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/18/23.
//

import Foundation
 
struct MarshallCipher: Cipher {
    
    let mask: UInt8
    init(mask: UInt8 = 219) {
        self.mask = mask
    }
    
    private func noiseTable() -> [UInt8] {
        [0xF0, 0xF5, 0xF3,
         0x0F, 0xBD, 0xC3,
         0xAF, 0x55, 0xDB,
         0x33, 0x3C, 0xCF,
         0x99, 0xCC]
    }
    
    private func expandKey(dataBytes: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: dataBytes.count)
        let noiseTable = noiseTable()
        var twiddle = Int32(5403)
        var noiseIndex: Int32 = 0
        var dataIndex = 0
        while dataIndex < dataBytes.count {
            let masked = dataBytes[dataIndex] & mask
            let noise = noiseTable[Int(noiseIndex)]
            twiddle = (twiddle << 1) * 33 + Int32(masked)
            twiddle ^= Int32(noise)
            twiddle += 17
            result[dataIndex] = UInt8(twiddle & 0xFF)
            noiseIndex += 1
            noiseIndex += Int32(masked) + (Int32(noise) << 1)
            noiseIndex = noiseIndex % Int32(noiseTable.count)
            twiddle = twiddle & 0xFFFFFF
            dataIndex += 1
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
        let antimask = ~mask
        let key = expandKey(dataBytes: dataBytes)
        var dataIndex = 0
        while dataIndex < dataBytes.count {
            let originalMasked = data[dataIndex] & mask
            dataBytes[dataIndex] ^= key[dataIndex]
            dataBytes[dataIndex] &= antimask
            dataBytes[dataIndex] |= originalMasked
            dataIndex += 1
        }
        return Data(dataBytes)
    }
}
