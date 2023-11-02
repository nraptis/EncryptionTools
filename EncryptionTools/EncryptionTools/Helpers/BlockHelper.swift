//
//  BlockHelper.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct BlockHelper {
    static func dataToBlocks(data: [UInt8], blockSize size: Int) -> [[UInt8]] {
        let blockSize = max(1, size)
        var result = [[UInt8]]()
        var dataIndex = 0
        while dataIndex < data.count {
            var block = [UInt8]()
            block.reserveCapacity(blockSize)
            var count = 0
            while count < blockSize && dataIndex < data.count {
                block.append(data[dataIndex])
                count += 1
                dataIndex += 1
            }
            result.append(block)
        }
        return result
    }
    
    static func dataFromBlocks(blocks: [[UInt8]]) -> [UInt8] {
        return [UInt8](blocks.joined())
    }
}
