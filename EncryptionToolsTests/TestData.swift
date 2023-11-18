//
//  TestData.swift
//  EncryptionToolsTests
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct TestData {
    
    enum Level {
        case mini
        case normal
        case harsh
    }
    
    private static let level = Level.harsh
    
    static func all() -> [Data] {
        var result = [Data]()
        result.append(contentsOf: sequencesUp())
        result.append(contentsOf: sequencesUpShuffled())
        result.append(contentsOf: sequencesDown())
        result.append(contentsOf: sequencesFlat())
        result.append(contentsOf: sequencesFlatSpans())
        result.append(contentsOf: sequencesFlatSpansShuffled())
        result.append(contentsOf: sequencesRandomFlavor1())
        result.append(contentsOf: sequencesRandomFlavor2())
        result.append(contentsOf: sequencesRandomFlavor3())
        result.append(contentsOf: sequencesRandomTwoValues())
        result.append(contentsOf: sequencesRandomThreeValues())
        return result
    }
    
    static func sequencesUp() -> [Data] {
        var lengthCap: Int
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 40
        case .normal:
            lengthCap = 80
        case .harsh:
            lengthCap = 160
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
        switch TestData.level {
        case .mini:
            lengthCap = 200
            loopCap = 3
        case .normal:
            lengthCap = 800
            loopCap = 6
        case .harsh:
            lengthCap = 1400
            loopCap = 13
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
        switch TestData.level {
        case .mini:
            count = 250
            maximumSize = 256
        case .normal:
            count = 1000
            maximumSize = 512
        case .harsh:
            count = 2000
            maximumSize = 2048
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
        let maximumSize: Int = 16
        switch TestData.level {
        case .mini:
            count = 512
        case .normal:
            count = 1024
        case .harsh:
            count = 4096
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
        let maximumSize: Int = 16
        switch TestData.level {
        case .mini:
            count = 512
        case .normal:
            count = 1024
        case .harsh:
            count = 4096
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
        let maximumSize: Int = 16
        switch TestData.level {
        case .mini:
            count = 512
        case .normal:
            count = 1024
        case .harsh:
            count = 4096
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
