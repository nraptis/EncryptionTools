//
//  TestData.swift
//  EncryptionToolsTests
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct TestData {
    static func all() -> [Data] {
        var result = [Data]()
        result.append(contentsOf: sequencesUp())
        if EncryptionToolsTests.level != .mini {
            result.append(contentsOf: sequencesUpShuffled())
            result.append(contentsOf: sequencesDown())
            result.append(contentsOf: sequencesFlat())
            result.append(contentsOf: sequencesFlatSpans())
            result.append(contentsOf: sequencesFlatSpansShuffled())
        }
        result.append(contentsOf: sequencesRandomFlavor1())
        result.append(contentsOf: sequencesRandomFlavor2())
        result.append(contentsOf: sequencesRandomFlavor3())
        result.append(contentsOf: sequencesRandomTwoValues())
        result.append(contentsOf: sequencesRandomThreeValues())
        
        if EncryptionToolsTests.level != .mini {
            result.append(contentsOf: sequencesUpShuffled())
            result.append(contentsOf: sequencesFlatSpansShuffled())
            result.append(contentsOf: sequencesRandomFlavor1())
            result.append(contentsOf: sequencesRandomFlavor2())
            result.append(contentsOf: sequencesRandomFlavor3())
            result.append(contentsOf: sequencesRandomTwoValues())
            result.append(contentsOf: sequencesRandomThreeValues())
        }
        if EncryptionToolsTests.level == .harsh {
            result.append(contentsOf: sequencesRandomFlavor1())
            result.append(contentsOf: sequencesRandomFlavor2())
            result.append(contentsOf: sequencesRandomFlavor3())
            result.append(contentsOf: sequencesRandomTwoValues())
            result.append(contentsOf: sequencesRandomThreeValues())
        }
        return result
    }
    
    static func sequencesUp() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                var number = startNumber
                while loop < length {
                    bytes.append(UInt8(number))
                    
                    loop += 1
                    number += 1
                    if number == 256 {
                        number = 0
                    }
                }
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesUpShuffled() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                var number = startNumber
                while loop < length {
                    bytes.append(UInt8(number))
                    loop += 1
                    number += 1
                    if number == 256 {
                        number = 0
                    }
                }
                bytes.shuffle()
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesDown() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                var number = startNumber
                while loop < length {
                    bytes.append(UInt8(number))
                    loop += 1
                    number -= 1
                    if number == -1 {
                        number = 255
                    }
                }
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesFlat() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                while loop < length {
                    bytes.append(UInt8(startNumber))
                    loop += 1
                }
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesFlatSpans() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                var number = startNumber
                var spanIndex = 0
                let spanLength = Int.random(in: 1...40)
                while loop < length {
                    bytes.append(UInt8(number))
                    loop += 1
                    spanIndex += 1
                    if spanIndex >= spanLength {
                        spanIndex = 0
                        number += 1
                        if number >= 256 {
                            number -= 256
                        }
                    }
                }
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesFlatSpansShuffled() -> [Data] {
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 16
        case .normal:
            lengthCap = 64
        case .harsh:
            lengthCap = 128
        }
        var result = [Data]()
        var length = 1
        while length < lengthCap {
            var startNumber = 0
            while startNumber < 256 {
                var bytes = [UInt8]()
                var loop = 0
                var number = startNumber
                var spanIndex = 0
                let spanLength = Int.random(in: 1...40)
                while loop < length {
                    bytes.append(UInt8(number))
                    loop += 1
                    spanIndex += 1
                    if spanIndex >= spanLength {
                        spanIndex = 0
                        number += 1
                        if number >= 256 {
                            number -= 256
                        }
                    }
                }
                bytes.shuffle()
                result.append(Data(bytes))
                startNumber += 1
            }
            length += 1
        }
        return result
    }
    
    static func sequencesRandomFlavor1() -> [Data] {
        let loopCap: Int
        var lengthCap: Int
        switch EncryptionToolsTests.level {
        case .mini:
            lengthCap = 64
            loopCap = 4
        case .normal:
            lengthCap = 256
            loopCap = 8
        case .harsh:
            lengthCap = 1024
            loopCap = 16
        }
        var result = [Data]()
        for _ in 0..<loopCap {
            var length = 1
            while length < lengthCap {
                var bytes = [UInt8]()
                var loop = 0
                while loop < length {
                    bytes.append(UInt8(Int.random(in: 0...255)))
                    loop += 1
                }
                result.append(Data(bytes))
                length += 1
            }
        }
        return result
    }
    
    static func sequencesRandomFlavor2() -> [Data] {
        let count: Int
        let maximumSize: Int
        switch EncryptionToolsTests.level {
        case .mini:
            count = 128
            maximumSize = 64
        case .normal:
            count = 512
            maximumSize = 512
        case .harsh:
            count = 4096
            maximumSize = 1024
        }
        var result = [Data]()
        for _ in 0..<count {
            let length = Int.random(in: 0...maximumSize)
            var bytes = [UInt8]()
            var loop = 0
            while loop < length {
                bytes.append(UInt8(Int.random(in: 0...255)))
                loop += 1
            }
            result.append(Data(bytes))
        }
        return result
    }
    
    static func sequencesRandomFlavor3() -> [Data] {
        let count: Int
        let maximumSize: Int
        switch EncryptionToolsTests.level {
        case .mini:
            count = 128
            maximumSize = 64
        case .normal:
            count = 512
            maximumSize = 512
        case .harsh:
            count = 4096
            maximumSize = 1024
        }
        var result = [Data]()
        for _ in 0..<count {
            let length = Int.random(in: 0...maximumSize)
            var bytes = [UInt8]()
            var loop = 0
            while loop < length {
                bytes.append(UInt8(Int.random(in: 0...255)))
                loop += 1
            }
            result.append(Data(bytes))
        }
        return result
    }
    
    static func sequencesRandomTwoValues() -> [Data] {
        let count: Int
        let maximumSize: Int
        switch EncryptionToolsTests.level {
        case .mini:
            count = 128
            maximumSize = 64
        case .normal:
            count = 512
            maximumSize = 512
        case .harsh:
            count = 4096
            maximumSize = 1024
        }
        var result = [Data]()
        for _ in 0..<count {
            let length = Int.random(in: 0...maximumSize)
            var bytes = [UInt8]()
            var loop = 0
            let value1 = UInt8(Int.random(in: 0...255))
            let value2 = UInt8(Int.random(in: 0...255))
            while loop < length {
                if Bool.random() {
                    bytes.append(value1)
                } else {
                    bytes.append(value2)
                }
                loop += 1
            }
            result.append(Data(bytes))
        }
        return result
    }
    
    static func sequencesRandomThreeValues() -> [Data] {
        let count: Int
        let maximumSize: Int
        switch EncryptionToolsTests.level {
        case .mini:
            count = 128
            maximumSize = 64
        case .normal:
            count = 512
            maximumSize = 512
        case .harsh:
            count = 4096
            maximumSize = 1024
        }
        var result = [Data]()
        for _ in 0..<count {
            let length = Int.random(in: 0...maximumSize)
            var bytes = [UInt8]()
            var loop = 0
            let value1 = UInt8(Int.random(in: 0...255))
            let value2 = UInt8(Int.random(in: 0...255))
            let value3 = UInt8(Int.random(in: 0...255))
            while loop < length {
                let random = Int.random(in: 0...2)
                if random == 0 {
                    bytes.append(value1)
                } else if random == 1 {
                    bytes.append(value2)
                } else {
                    bytes.append(value3)
                }
                loop += 1
            }
            result.append(Data(bytes))
        }
        return result
    }
}
