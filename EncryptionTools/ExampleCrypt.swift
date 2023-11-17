//
//  ExampleCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct ExampleCrypt: Cryptable {
    func encrypt(data: Data) throws -> Data {
        var encrypted = data
        for crypt in crypts {
            encrypted = try crypt.encrypt(data: encrypted)
        }
        return encrypted
    }
    
    func decrypt(data: Data) throws -> Data {
        var decrypted = data
        for crypt in crypts.reversed() {
            decrypted = try crypt.decrypt(data: decrypted)
        }
        return decrypted
    }
    
    private var crypts: [Cryptable] {
        var result = [Cryptable]()
        result.append(RotateMaskCrypt(mask: 170, shift: 1))
        result.append(WeaveCrypt(count: 1, frontStride: 1, backStride: 0))
        result.append(RangeRotationCrypt(lowerBound: 36, upperBound: 180, shift: -17))
        
        result.append(PasswordCrypt(password: "EnCrYpTiOn"))
        result.append(RotateMaskCrypt(mask: 204, shift: -1))
        result.append(WeaveCrypt(count: 2, frontStride: 0, backStride: 1))
        result.append(RangeRotationCrypt(lowerBound: 121, upperBound: 255, shift: 14))
        
        result.append(RotateMaskBlockCrypt(blockSize: 6, mask: 240, shift: 1))
        result.append(WeaveCrypt(count: 1, frontStride: 1, backStride: 1))
        result.append(RangeRotationCrypt(lowerBound: 0, upperBound: 111, shift: -20))
        
        return result
    }
}
