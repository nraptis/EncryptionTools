//
//  EncryptionToolsTests.swift
//  EncryptionToolsTests
//
//  Created by Nicky Taylor on 11/1/23.
//

import XCTest
@testable import EncryptionTools

final class EncryptionToolsTests: XCTestCase {

    func testAES() {
        let keys = [String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64)]
        let nonces = [String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24)]
        var loops = 0
        for key in keys {
            for nonce in nonces {
                let datas = TestData.all()
                let crypt = AESCrypt(key: key, nonce: nonce)
                loops += DataCompare.execute(crypt: crypt, datas: datas, name: "aes")
            }
        }
        print("executed \(loops) tests! aes encryption!")
    }
    
    func testChaChaPoly() {
        let keys = [String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64),
                    String.randomHexString(length: 64)]
        let nonces = [String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24),
                      String.randomHexString(length: 24)]
        var loops = 0
        for key in keys {
            for nonce in nonces {
                let datas = TestData.all()
                let crypt = ChaChaPolyCrypt(key: key, nonce: nonce)
                loops += DataCompare.execute(crypt: crypt, datas: datas, name: "aes")
            }
        }
        print("executed \(loops) tests! cha cha poly encryption!")
    }

    func testPassword() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let password = String.randomUTF8String(length: Int.random(in: 1...32))
                let crypt = PasswordCrypt(password: password)
                DataCompare.execute(crypt: crypt, data: data, name: "password (\(password))")
                loops += 1
            }
        }
        print("executed \(loops) tests! password encryption!")
    }
    
    func testTaylor() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let password1 = String.randomUTF8String(length: Int.random(in: 1...32))
                let password2 = String.randomUTF8String(length: Int.random(in: 1...32))
                let crypt = TaylorCrypt(password1: password1, password2: password2)
                DataCompare.execute(crypt: crypt, data: data, name: "taylor (password1 \(password1), password2 \(password2)")
                loops += 1
            }
        }
        print("executed \(loops) tests! taylor encryption!")
    }
    
    func testRotateMask() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let mask = UInt8.random(in: 0...255)
                let shift = Int.random(in: -1024...1024)
                let crypt = RotateMaskCrypt(mask: mask, shift: shift)
                DataCompare.execute(crypt: crypt, data: data, name: "rotate mask (mask \(mask), shift \(shift))")
                loops += 1
            }
        }
        print("executed \(loops) tests! rotate mask encryption!")
    }
    
    func testRotateMaskBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let mask = UInt8.random(in: 0...255)
                let shift = Int.random(in: -1024...1024)
                let crypt = RotateMaskBlockCrypt(blockSize: blockSize, mask: mask, shift: shift)
                DataCompare.execute(crypt: crypt, data: data, name: "rotate mask block (size \(blockSize), mask \(mask), shift \(shift))")
                loops += 1
            }
        }
        print("executed \(loops) tests! rotate mask block encryption!")
    }
    
    func testRotate() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let shift = Int.random(in: -1024...1024)
                let crypt = RotateCrypt(shift: shift)
                DataCompare.execute(crypt: crypt, data: data, name: "rotate (\(shift))")
                loops += 1
            }
        }
        print("executed \(loops) tests! rotate encryption!")
    }
    
    func testRotateBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let shift = Int.random(in: -1024...1024)
                let crypt = RotateBlockCrypt(blockSize: blockSize, shift: shift)
                DataCompare.execute(crypt: crypt, data: data, name: "rotate block (size \(blockSize), shift \(shift))")
                loops += 1
            }
        }
        print("executed \(loops) tests! rotate block encryption!")
    }
    
    func testWeaveByteBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveByteBlockCrypt(blockSize: blockSize,
                                            count: count,
                                            frontStride: frontStride,
                                            backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave byte block (size \(blockSize), count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave byte block encryption!")
    }
    
    func testWeaveMaskByteBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let mask = UInt8.random(in: 0...255)
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveMaskByteBlockCrypt(blockSize: blockSize,
                                                    mask: mask,
                                                    count: count,
                                                    frontStride: frontStride,
                                                    backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave mask byte block (size \(blockSize), mask \(mask), count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave mask byte block encryption!")
    }
    
    func testWeaveBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveBlockCrypt(blockSize: blockSize,
                                            count: count,
                                            frontStride: frontStride,
                                            backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave block (size \(blockSize), count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave block encryption!")
    }
    
    func testWeaveMaskBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let mask = UInt8.random(in: 0...255)
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveMaskBlockCrypt(blockSize: blockSize,
                                                mask: mask,
                                                count: count,
                                                frontStride: frontStride,
                                                backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave mask block (size \(blockSize), mask \(mask), count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave mask block encryption!")
    }
    
    func testWeave() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveCrypt(count: count,
                                       frontStride: frontStride,
                                       backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave (count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave encryption!")
    }
    
    func testWeaveMask() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let mask = UInt8.random(in: 0...255)
                let count = Int.random(in: 0...10)
                let frontStride = Int.random(in: -1...6)
                let backStride = Int.random(in: -1...6)
                let crypt = WeaveMaskCrypt(mask: mask,
                                           count: count,
                                           frontStride: frontStride,
                                           backStride: backStride)
                DataCompare.execute(crypt: crypt, data: data, name: "weave mask (mask \(mask), count \(count), front \(frontStride), back \(backStride))")
                loops += 1
            }
        }
        print("executed \(loops) tests! weave mask encryption!")
    }
    
    func testSplint() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = SplintCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "splint")
        }
        print("executed \(loops) tests! splint encryption!")
    }
    
    func testSplintBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let crypt = SplintBlockCrypt(blockSize: blockSize)
                DataCompare.execute(crypt: crypt, data: data, name: "splint block (\(blockSize))")
                loops += 1
            }
        }
        print("executed \(loops) tests! splint block encryption!")
    }
    
    func testSplintByteBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let crypt = SplintByteBlockCrypt(blockSize: blockSize)
                DataCompare.execute(crypt: crypt, data: data, name: "splint byte block (\(blockSize))")
                loops += 1
            }
        }
        print("executed \(loops) tests! splint byte block encryption!")
    }
    
    func testShuffle() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = ShuffleCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "shuffle")
        }
        print("executed \(loops) tests! shuffle encryption!")
    }
    
    func testJulian() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = JulianCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "julian")
        }
        print("executed \(loops) tests! julian encryption!")
    }
    
    
    func testInvert() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = InvertCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "invert")
        }
        print("executed \(loops) tests! invert encryption!")
    }
    
    func testReverse() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = ReverseCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "reverse")
        }
        print("executed \(loops) tests! reverse encryption!")
    }
    
    func testRangeRotation() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let numberOfRanges = Int.random(in: 1...16)
                var ranges = [RangeRotationCrypt.RotationElement]()
                for _ in 0..<numberOfRanges {
                    ranges.append(.init(rangeStart: Int.random(in: 0...255),
                                        rangeEnd: Int.random(in: 0...255),
                                        amount: Int.random(in: -1024...1024)))
                }
                let crypt = RangeRotationCrypt(elements: ranges)
                DataCompare.execute(crypt: crypt, data: data, name: "splint byte block (\(ranges))")
            }
            
            let crypt = ReverseCrypt()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "invert")
        }
        print("executed \(loops) tests! invert encryption!")
    }
    

}
