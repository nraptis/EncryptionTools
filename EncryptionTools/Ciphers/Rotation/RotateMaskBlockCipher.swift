//
//  RotateMaskBlockCipher.swift
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

struct RotateMaskBlockCipher: Cipher {
    let blockSize: Int
    let mask: UInt8
    let shift: Int
    init(blockSize: Int = 5, mask: UInt8 = 240, shift: Int = -1) {
        self.blockSize = blockSize
        self.mask = mask
        self.shift = shift
    }
    
    func encrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        dataBytes.removeAll()
        if blocks.count <= 0 { return data }
        for blockIndex in blocks.indices {
            var dataBytesRotated = [UInt8]()
            dataBytesRotated.reserveCapacity(blocks[blockIndex].count)
            var rotation = shift % blocks[blockIndex].count
            if rotation < 0 { rotation += blocks[blockIndex].count }
            var index = rotation
            while index < blocks[blockIndex].count {
                dataBytesRotated.append(blocks[blockIndex][index])
                index += 1
            }
            index = 0
            while index < rotation {
                dataBytesRotated.append(blocks[blockIndex][index])
                index += 1
            }
            let antimask = ~mask
            for byteIndex in blocks[blockIndex].indices {
                blocks[blockIndex][byteIndex] &= antimask
                blocks[blockIndex][byteIndex] |= (dataBytesRotated[byteIndex] & mask)
            }
        }
        return Data(BlockHelper.dataFromBlocks(blocks: blocks))
    }
    
    func decrypt(data: Data) throws -> Data {
        if data.count <= 0 { return data }
        var dataBytes = [UInt8](data)
        var blocks = BlockHelper.dataToBlocks(data: dataBytes, blockSize: blockSize)
        dataBytes.removeAll()
        if blocks.count <= 0 { return data }
        for blockIndex in blocks.indices {
            var dataBytesRotated = [UInt8]()
            dataBytesRotated.reserveCapacity(blocks[blockIndex].count)
            var rotation = (-shift) % blocks[blockIndex].count
            if rotation < 0 { rotation += blocks[blockIndex].count }
            var index = rotation
            while index < blocks[blockIndex].count {
                dataBytesRotated.append(blocks[blockIndex][index])
                index += 1
            }
            index = 0
            while index < rotation {
                dataBytesRotated.append(blocks[blockIndex][index])
                index += 1
            }
            let antimask = ~mask
            for byteIndex in blocks[blockIndex].indices {
                blocks[blockIndex][byteIndex] &= antimask
                blocks[blockIndex][byteIndex] |= (dataBytesRotated[byteIndex] & mask)
            }
        }
        return Data(BlockHelper.dataFromBlocks(blocks: blocks))
    }
}
