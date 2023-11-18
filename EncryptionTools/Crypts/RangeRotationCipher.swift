//
//  RangeRotationCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum RangeRotationCipherError: Error {
    case badRange
}

struct RangeRotationCipher: Cipher {
    let lowerBound: Int
    let upperBound: Int
    let shift: Int
    init(lowerBound: Int, upperBound: Int, shift: Int) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.shift = shift
    }
    
    func encrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 {
            return data
        }
        if lowerBound < 0 { throw RangeRotationCipherError.badRange }
        if lowerBound > 255 { throw RangeRotationCipherError.badRange }
        if upperBound > 255 { throw RangeRotationCipherError.badRange }
        if upperBound < 0 { throw RangeRotationCipherError.badRange }
        let rangeSpan = (upperBound - lowerBound) + 1
        for dataIndex in 0..<dataBytes.count {
            var value = Int(dataBytes[dataIndex])
            if value >= lowerBound && value <= upperBound {
                value -= lowerBound
                value += shift
                value = value % rangeSpan
                if value < 0 {
                    value += rangeSpan
                }
                value += lowerBound
            }
            dataBytes[dataIndex] = UInt8(value)
        }
        return Data(dataBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 {
            return data
        }
        if lowerBound < 0 { throw RangeRotationCipherError.badRange }
        if lowerBound > 255 { throw RangeRotationCipherError.badRange }
        if upperBound > 255 { throw RangeRotationCipherError.badRange }
        if upperBound < 0 { throw RangeRotationCipherError.badRange }
        let rangeSpan = (upperBound - lowerBound) + 1
        for dataIndex in 0..<dataBytes.count {
            var value = Int(dataBytes[dataIndex])
            if value >= lowerBound && value <= upperBound {
                value -= lowerBound
                value -= shift
                value = value % rangeSpan
                if value < 0 {
                    value += rangeSpan
                }
                value += lowerBound
            }
            dataBytes[dataIndex] = UInt8(value)
        }
        return Data(dataBytes)
    }
}
