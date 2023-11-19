//
//  ShuffleCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct ShuffleCipher: Cipher {
    func encrypt(data: Data) throws -> Data {
        let dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        var resultBytes = [UInt8]()
        var leftStack = [Int]()
        var rightStack = [Int]()
        leftStack.append(0)
        rightStack.append(dataBytes.count - 1)
        while leftStack.count > 0 {
            let left = leftStack.popLast()!
            let right = rightStack.popLast()!
            if (right - left) <= 1 {
                var index = left
                while index <= right {
                    resultBytes.append(dataBytes[index])
                    index += 1
                }
                continue
            }
            let middle = (left + right) / 2
            resultBytes.append(dataBytes[middle])
            leftStack.append(middle + 1)
            rightStack.append(right)
            leftStack.append(left)
            rightStack.append(middle - 1)
        }
        return Data(resultBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        let dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        var resultBytes = [UInt8]()
        var leftStack = [Int]()
        var rightStack = [Int]()
        leftStack.append(0)
        rightStack.append(dataBytes.count - 1)
        while leftStack.count > 0 {
            let left = leftStack.popLast()!
            let right = rightStack.popLast()!
            if (right - left) <= 1 {
                var index = left
                while index <= right {
                    resultBytes.append(dataBytes[index])
                    index += 1
                }
                continue
            }
            let middle = (left + right) / 2
            leftStack.append(middle + 1)
            rightStack.append(right)
            leftStack.append(left)
            rightStack.append(left)
            leftStack.append(left + 1)
            rightStack.append(middle)
        }
        return Data(resultBytes)
    }
}
