//
//  SplintMaskCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/18/23.
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
    
struct SplintMaskCipher: Cipher {
    
    let mask: UInt8
    init(mask: UInt8 = 219) {
        self.mask = mask
    }
    
    func encrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        var list1 = [UInt8]()
        var list2 = [UInt8]()
        let half = (dataBytes.count + 1) / 2
        let antimask = ~mask
        var index = 0
        while index < half {
            list1.append(dataBytes[index] & mask)
            dataBytes[index] &= antimask
            index += 1
        }
        while index < dataBytes.count {
            list2.append(dataBytes[index] & mask)
            dataBytes[index] &= antimask
            index += 1
        }
        index = 0
        var index1 = 0
        var index2 = 0
        while index1 < list1.count && index2 < list2.count {
            dataBytes[index] |= list1[index1]
            index += 1
            index1 += 1
            dataBytes[index] |= list2[index2]
            index += 1
            index2 += 1
        }
        while index1 < list1.count {
            dataBytes[index] |= list1[index1]
            index += 1
            index1 += 1
        }
        while index2 < list2.count {
            dataBytes[index] |= list2[index2]
            index += 1
            index2 += 1
        }
        return Data(dataBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        var list1 = [UInt8]()
        var list2 = [UInt8]()
        let antimask = ~mask
        var index = 0
        while index < dataBytes.count {
            if (index & 1) == 0 {
                list1.append(dataBytes[index] & mask)
                dataBytes[index] &= antimask
            } else {
                list2.append(dataBytes[index] & mask)
                dataBytes[index] &= antimask
            }
            index += 1
        }
        index = 0
        var index1 = 0
        while index1 < list1.count {
            dataBytes[index] |= list1[index1]
            index += 1
            index1 += 1
        }
        var index2 = 0
        while index2 < list2.count {
            dataBytes[index] |= list2[index2]
            index += 1
            index2 += 1
        }
        return Data(dataBytes)
    }
}
