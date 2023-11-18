//
//  ExampleCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct ExampleCipher: Cipher {
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
    
    private var crypts: [Cipher] {
        var result = [Cipher]()
        result.append(RotateMaskCipher(mask: 170, shift: 1))
        result.append(WeaveCipher(count: 1, frontStride: 1, backStride: 0))
        result.append(RangeRotationCipher(lowerBound: 36, upperBound: 180, shift: -17))
        
        result.append(PasswordCipher(password: "EnCrYpTiOn"))
        result.append(RotateMaskCipher(mask: 204, shift: -1))
        result.append(WeaveCipher(count: 2, frontStride: 0, backStride: 1))
        result.append(RangeRotationCipher(lowerBound: 121, upperBound: 255, shift: 14))
        
        result.append(RotateMaskBlockCipher(blockSize: 6, mask: 240, shift: 1))
        result.append(WeaveCipher(count: 1, frontStride: 1, backStride: 1))
        result.append(RangeRotationCipher(lowerBound: 0, upperBound: 111, shift: -20))
        
        return result
    }
}
