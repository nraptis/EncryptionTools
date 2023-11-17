//
//  UnbreakableCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/16/23.
//

import Foundation

struct UnbreakableCrypt: Cryptable {
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
        
        // Chapter 1 - Losing It
        result.append(WeaveMaskCrypt(mask: 153, count: 1, frontStride: 1, backStride: 1))
        result.append(RotateMaskCrypt(mask: 240, shift: 31))
        result.append(SplintCrypt())
        result.append(RangeRotationCrypt(lowerBound: 65, upperBound: 140, shift: 14))
        result.append(RotateMaskBlockCrypt(blockSize: 8, mask: 195, shift: -1))
        result.append(InvertMaskCrypt(mask: 60))
        result.append(WeaveMaskBlockCrypt( blockSize: 12, mask: 15, count: 2, frontStride: 1, backStride: 0))
        result.append(ReverseMaskCrypt(mask: 85))
        result.append(ShuffleCrypt())
        
        // Chapter 2 - Bloody Knees
        result.append(SplintBlockCrypt(blockSize: 11))
        result.append(WeaveMaskCrypt(mask: 195, count: 2, frontStride: 0, backStride: 1))
        result.append(RotateMaskBlockCrypt(blockSize: 5, mask: 204, shift: 23))
        result.append(ReverseMaskCrypt(mask: 51))
        result.append(JulianCrypt())
        result.append(RotateMaskCrypt(mask: 15, shift: -7))
        result.append(WeaveMaskBlockCrypt( blockSize: 6, mask: 170, count: 1, frontStride: 0, backStride: 2))
        result.append(InvertMaskCrypt(mask: 153))
        result.append(RangeRotationCrypt(lowerBound: 24, upperBound: 70, shift: -3))
        
        // Chapter 3 - Toxic Vampire
        result.append(WeaveMaskBlockCrypt( blockSize: 12, mask: 195, count: 2, frontStride: 1, backStride: 0))
        result.append(InvertMaskCrypt(mask: 15))
        result.append(WeaveMaskCrypt(mask: 153, count: 5, frontStride: 3, backStride: 2))
        result.append(RotateMaskBlockCrypt(blockSize: 6, mask: 170, shift: -1))
        result.append(SplintByteBlockCrypt(blockSize: 5))
        result.append(ReverseMaskCrypt(mask: 240))
        result.append(RotateMaskCrypt(mask: 60, shift: 57))
        result.append(RangeRotationCrypt(lowerBound: 188, upperBound: 200, shift: 1))
        result.append(ShuffleCrypt())
        
        return result
    }
}
