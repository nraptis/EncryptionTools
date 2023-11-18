//
//  UnbreakableCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/16/23.
//

import Foundation

struct UnbreakableCipher: Cipher {
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
        
        // Chapter 1 - Losing It
        result.append(WeaveMaskCipher(mask: 153, count: 1, frontStride: 1, backStride: 1))
        result.append(RotateMaskCipher(mask: 240, shift: 31))
        result.append(SplintCipher())
        result.append(RangeRotationCipher(lowerBound: 65, upperBound: 140, shift: 14))
        result.append(RotateMaskBlockCipher(blockSize: 8, mask: 195, shift: -1))
        result.append(InvertMaskCipher(mask: 60))
        result.append(WeaveMaskBlockCipher( blockSize: 12, mask: 15, count: 2, frontStride: 1, backStride: 0))
        result.append(ReverseMaskCipher(mask: 85))
        result.append(ShuffleCipher())
        
        // Chapter 2 - Bloody Knees
        result.append(SplintBlockCipher(blockSize: 11))
        result.append(WeaveMaskCipher(mask: 195, count: 2, frontStride: 0, backStride: 1))
        result.append(RotateMaskBlockCipher(blockSize: 5, mask: 204, shift: 23))
        result.append(ReverseMaskCipher(mask: 51))
        result.append(JulianCipher())
        result.append(RotateMaskCipher(mask: 15, shift: -7))
        result.append(WeaveMaskBlockCipher( blockSize: 6, mask: 170, count: 1, frontStride: 0, backStride: 2))
        result.append(InvertMaskCipher(mask: 153))
        result.append(RangeRotationCipher(lowerBound: 24, upperBound: 70, shift: -3))
        
        // Chapter 3 - Toxic Vampire
        result.append(WeaveMaskBlockCipher( blockSize: 12, mask: 195, count: 2, frontStride: 1, backStride: 0))
        result.append(InvertMaskCipher(mask: 15))
        result.append(WeaveMaskCipher(mask: 153, count: 5, frontStride: 3, backStride: 2))
        result.append(RotateMaskBlockCipher(blockSize: 6, mask: 170, shift: -1))
        result.append(SplintByteBlockCipher(blockSize: 5))
        result.append(ReverseMaskCipher(mask: 240))
        result.append(RotateMaskCipher(mask: 60, shift: 57))
        result.append(RangeRotationCipher(lowerBound: 188, upperBound: 200, shift: 1))
        result.append(ShuffleCipher())
        
        return result
    }
}
