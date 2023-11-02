//
//  SplintBlockCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct SplintBlockCrypt: Cryptable {
    let blockSize: Int
    init(blockSize: Int = 3) {
        self.blockSize = blockSize
    }
    
    func encrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        dataBytes.removeAll()
        if blocks.count <= 0 { return data }
        var list1 = [[UInt8]]()
        var list2 = [[UInt8]]()
        var ceiling = blocks.count - 1
        if blocks[blocks.count - 1].count != blockSize {
            ceiling -= 1
        }
        let half = (ceiling + 1) / 2
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
        return Data(BlockHelper.dataFromBlocks(blocks: blocks))
    }
    
    func decrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        dataBytes.removeAll()
        if blocks.count <= 0 { return data }
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
        return Data(BlockHelper.dataFromBlocks(blocks: blocks))
    }
}
