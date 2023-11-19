//
//  JulianCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct JulianCipher: Cipher {
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
            let count = (right - left) + 1
            if count > 6 {
                let middle = (left + right + 1) / 2
                leftStack.append(middle + 1)
                rightStack.append(right)
                leftStack.append(left)
                rightStack.append(left)
                leftStack.append(left + 1)
                rightStack.append(middle)
            } else if count == 6 {
                resultBytes.append(dataBytes[left + 3])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 5])
                resultBytes.append(dataBytes[left + 4])
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 2])
            } else if count == 5 {
                resultBytes.append(dataBytes[left + 2])
                resultBytes.append(dataBytes[left + 4])
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 3])
            } else if count == 4 {
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 3])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 2])
            } else if count == 3 {
                resultBytes.append(dataBytes[left + 2])
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 0])
            } else if count == 2 {
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 0])
            } else if count == 1 {
                resultBytes.append(dataBytes[left + 0])
            }
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
            let count = (right - left) + 1
            if count > 6 {
                let middle = (left + right + 1) / 2
                resultBytes.append(dataBytes[middle])
                leftStack.append(middle + 1)
                rightStack.append(right)
                leftStack.append(left)
                rightStack.append(middle - 1)
            } else if count == 6 {
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 4])
                resultBytes.append(dataBytes[left + 5])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 3])
                resultBytes.append(dataBytes[left + 2])
            } else if count == 5 {
                resultBytes.append(dataBytes[left + 3])
                resultBytes.append(dataBytes[left + 2])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 4])
                resultBytes.append(dataBytes[left + 1])
            } else if count == 4 {
                resultBytes.append(dataBytes[left + 2])
                resultBytes.append(dataBytes[left + 0])
                resultBytes.append(dataBytes[left + 3])
                resultBytes.append(dataBytes[left + 1])
            } else if count == 3 {
                resultBytes.append(dataBytes[left + 2])
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 0])
            } else if count == 2 {
                resultBytes.append(dataBytes[left + 1])
                resultBytes.append(dataBytes[left + 0])
            } else if count == 1 {
                resultBytes.append(dataBytes[left + 0])
            }
        }
        return Data(resultBytes)
    }
}
