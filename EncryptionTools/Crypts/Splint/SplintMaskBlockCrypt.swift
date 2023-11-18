//
//  SplintMaskBlockCrypt.swift
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

struct SplintMaskBlockCrypt: Cryptable {
    
    let blockSize: Int
    let mask: UInt8
    init(blockSize: Int = 7, mask: UInt8 = 219) {
        self.blockSize = blockSize
        self.mask = mask
    }
    
    func encrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        if blocks.count <= 0 { return data }
        var list1 = [[UInt8]]()
        var list2 = [[UInt8]]()
        var ceiling = blocks.count - 1
        if blocks[blocks.count - 1].count != blockSize {
            ceiling -= 1
        }
        let half = (ceiling + 1) / 2
        let antimask = ~mask
        var blockIndex = 0
        while blockIndex < half {
            list1.append(blocks[blockIndex])
            blockIndex += 1
        }
        while blockIndex < ceiling {
            list2.append(blocks[blockIndex])
            blockIndex += 1
        }
        var index = 0
        var index1 = 0
        var index2 = 0
        while index1 < list1.count && index2 < list2.count {
            blocks[index] = list1[index1]
            index += 1
            index1 += 1
            blocks[index] = list2[index2]
            index += 1
            index2 += 1
        }
        while index1 < list1.count {
            blocks[index] = list1[index1]
            index += 1
            index1 += 1
        }
        while index2 < list2.count {
            blocks[index] = list2[index2]
            index += 1
            index2 += 1
        }
        index = 0
        blockIndex = 0
        while blockIndex < blocks.count {
            var byteIndex = 0
            while byteIndex < blocks[blockIndex].count {
                dataBytes[index] &= antimask
                dataBytes[index] |= (blocks[blockIndex][byteIndex] & mask)
                byteIndex += 1
                index += 1
            }
            blockIndex += 1
        }
        list1.removeAll()
        list2.removeAll()
        blocks.removeAll()
        return Data(dataBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        if blocks.count <= 0 { return data }
        let antimask = ~mask
        var list1 = [[UInt8]]()
        var list2 = [[UInt8]]()
        var ceiling = blocks.count - 1
        if blocks[blocks.count - 1].count != blockSize {
            ceiling -= 1
        }
        var index = 0
        while index < ceiling {
            if (index & 1) == 0 {
                list1.append(blocks[index])
            } else {
                list2.append(blocks[index])
            }
            index += 1
        }
        index = 0
        var index1 = 0
        while index1 < list1.count {
            blocks[index] = list1[index1]
            index += 1
            index1 += 1
        }
        var index2 = 0
        while index2 < list2.count {
            blocks[index] = list2[index2]
            index += 1
            index2 += 1
        }
        var blockIndex = 0
        index = 0
        while blockIndex < blocks.count {
            var byteIndex = 0
            while byteIndex < blocks[blockIndex].count {
                dataBytes[index] &= antimask
                dataBytes[index] |= (blocks[blockIndex][byteIndex] & mask)
                byteIndex += 1
                index += 1
            }
            blockIndex += 1
        }
        list1.removeAll()
        list2.removeAll()
        blocks.removeAll()
        return Data(dataBytes)
    }
}
