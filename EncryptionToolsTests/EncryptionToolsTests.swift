//
//  EncryptionToolsTests.swift
//  EncryptionToolsTests
//
//  Created by Nicky Taylor on 11/1/23.
//

import XCTest
@testable import EncryptionTools

final class EncryptionToolsTests: XCTestCase {

    enum Level {
        case mini
        case normal
        case harsh
    }
    
    //
    // Test Times From 11/19/2023 - 11/20/2023
    //
    //Level.mini
    //Executed 28 tests, with 0 failures (0 unexpected) in 34.454 (34.454) seconds
    //
    //Level.normal
    //Executed 28 tests, with 0 failures (0 unexpected) in 2749.294 (2749.298) seconds
    //
    //Level.harsh
    //Executed 28 tests, with 0 failures (0 unexpected) in 13465.661 (13465.691) seconds
    //
    
    static let level = Level.harsh
    
    func testAES() {
        var keys = [String]()
        var nonces = [String]()
        switch Self.level {
        case .mini:
            keys.append(String.randomHexString(length: 64))
            nonces.append(String.randomHexString(length: 24))
        default:
            for _ in 0..<3 {
                keys.append(String.randomHexString(length: 64))
                nonces.append(String.randomHexString(length: 24))
            }
        }
        var loops = 0
        for key in keys {
            for nonce in nonces {
                let datas = TestData.all()
                let crypt = AESCipher(key: key, nonce: nonce)
                loops += DataCompare.execute(crypt: crypt, datas: datas, name: "aes")
            }
        }
        print("executed \(loops) tests! aes encryption!")
    }
    
    func testChaChaPoly() {
        var keys = [String]()
        var nonces = [String]()
        switch Self.level {
        case .mini:
            keys.append(String.randomHexString(length: 64))
            nonces.append(String.randomHexString(length: 24))
        default:
            for _ in 0..<3 {
                keys.append(String.randomHexString(length: 64))
                nonces.append(String.randomHexString(length: 24))
            }
        }
        var loops = 0
        for key in keys {
            for nonce in nonces {
                let datas = TestData.all()
                let crypt = ChaChaPolyCipher(key: key, nonce: nonce)
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
                let crypt = PasswordCipher(password: password)
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
                let crypt = TaylorCipher(password1: password1, password2: password2)
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
                let crypt = RotateMaskCipher(mask: mask, shift: shift)
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
                let crypt = RotateMaskBlockCipher(blockSize: blockSize, mask: mask, shift: shift)
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
                let crypt = RotateCipher(shift: shift)
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
                let crypt = RotateBlockCipher(blockSize: blockSize, shift: shift)
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
                let crypt = WeaveByteBlockCipher(blockSize: blockSize,
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
                let crypt = WeaveMaskByteBlockCipher(blockSize: blockSize,
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
                let crypt = WeaveBlockCipher(blockSize: blockSize,
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
                let crypt = WeaveMaskBlockCipher(blockSize: blockSize,
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
                let crypt = WeaveCipher(count: count,
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
                let crypt = WeaveMaskCipher(mask: mask,
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
            let crypt = SplintCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "splint")
        }
        print("executed \(loops) tests! splint encryption!")
    }
    
    func testSplintMask() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let crypt = SplintMaskCipher(mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "splint mask (\(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! splint mask encryption!")
    }
    
    func testSplintBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let crypt = SplintBlockCipher(blockSize: blockSize)
                DataCompare.execute(crypt: crypt, data: data, name: "splint block (\(blockSize))")
                loops += 1
            }
        }
        print("executed \(loops) tests! splint block encryption!")
    }
    
    func testSplintMaskBlock() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let blockSize = Int.random(in: 1...64)
                    let crypt = SplintMaskBlockCipher(blockSize: blockSize, mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "splint mask block (blockSize \(blockSize), mask \(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! splint mask block encryption!")
    }
    
    func testSplintByteBlock() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            for data in datas {
                let blockSize = Int.random(in: 1...64)
                let crypt = SplintByteBlockCipher(blockSize: blockSize)
                DataCompare.execute(crypt: crypt, data: data, name: "splint byte block (\(blockSize))")
                loops += 1
            }
        }
        print("executed \(loops) tests! splint byte block encryption!")
    }
    
    func testSplintMaskByteBlock() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let blockSize = Int.random(in: 1...64)
                    let crypt = SplintMaskByteBlockCipher(blockSize: blockSize, mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "splint mask byte block (blockSize \(blockSize), mask \(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! splint mask byte block encryption!")
    }
    
    func testShuffle() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = ShuffleCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "shuffle")
        }
        print("executed \(loops) tests! shuffle encryption!")
    }
    
    func testJulian() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = JulianCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "julian")
        }
        print("executed \(loops) tests! julian encryption!")
    }
    
    
    func testInvert() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = InvertCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "invert")
        }
        print("executed \(loops) tests! invert encryption!")
    }
    
    func testInvertMask() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let crypt = InvertMaskCipher(mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "invert mask (mask \(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! invert mask encryption!")
    }
    
    func testReverse() {
        var loops = 0
        for _ in 0..<20 {
            let datas = TestData.all()
            let crypt = ReverseCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "reverse")
        }
        print("executed \(loops) tests! reverse encryption!")
    }
    
    func testReverseMask() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let crypt = ReverseMaskCipher(mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "reverse mask (mask \(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! reverse mask encryption!")
    }
    
    func testRangeRotation() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let lowerBound = Int.random(in: 0...255)
                    let upperBound = Int.random(in: 0...255)
                    let shift = Int.random(in: -1024...1024)
                    let crypt = RangeRotationCipher(lowerBound: lowerBound,
                                                   upperBound: upperBound,
                                                   shift: shift)
                    DataCompare.execute(crypt: crypt, data: data, name: "range rotation (lowerBound \(lowerBound), upperBound \(upperBound), shift \(shift))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! range rotation encryption!")
    }
    
    func testMarshall() {
        var loops = 0
        for _ in 0..<10 {
            let datas = TestData.all()
            for data in datas {
                for _ in 0..<5 {
                    let mask = UInt8.random(in: 0...255)
                    let crypt = MarshallCipher(mask: mask)
                    DataCompare.execute(crypt: crypt, data: data, name: "marshall (\(mask))")
                    loops += 1
                }
            }
        }
        print("executed \(loops) tests! marshall encryption!")
    }
    
    
    
    /*
    func testExample() {
        var loops = 0
        for _ in 0..<5 {
            let datas = TestData.all()
            let crypt = ExampleCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "example")
        }
        print("executed \(loops) tests! example encryption!")
    }
    
    func testUnbreakable() {
        var loops = 0
        for _ in 0..<5 {
            let datas = TestData.all()
            let crypt = UnbreakableCipher()
            loops += DataCompare.execute(crypt: crypt, datas: datas, name: "example")
        }
        print("executed \(loops) tests! unbreakable encryption!")
    }
    */
}
