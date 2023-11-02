//
//  RangeRotationCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum RangeRotationCryptError: Error {
    case badRange
}

struct RangeRotationCrypt: Cryptable {
    struct RotationElement {
        let rangeStart: Int
        let rangeEnd: Int
        let amount: Int
    }
    var elements: [RotationElement]
    init(elements: [RotationElement] = [RotationElement(rangeStart: 13, rangeEnd: 17, amount: 10),
                                        RotationElement(rangeStart: 21, rangeEnd: 28, amount: 6),
                                        RotationElement(rangeStart: 36, rangeEnd: 58, amount: -11),
                                        RotationElement(rangeStart: 64, rangeEnd: 75, amount: 7),
                                        RotationElement(rangeStart: 83, rangeEnd: 110, amount: -3),
                                        RotationElement(rangeStart: 114, rangeEnd: 134, amount: 23),
                                        RotationElement(rangeStart: 156, rangeEnd: 161, amount: 2),
                                        RotationElement(rangeStart: 173, rangeEnd: 220, amount: 19),
                                        RotationElement(rangeStart: 231, rangeEnd: 255, amount: -4)]) {
        self.elements = elements
    }
    
    func encrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 {
            return data
        }
        for element in elements {
            if element.rangeStart < 0 { throw RangeRotationCryptError.badRange }
            if element.rangeStart > 255 { throw RangeRotationCryptError.badRange }
            if element.rangeEnd > 255 { throw RangeRotationCryptError.badRange }
            if element.rangeEnd < 0 { throw RangeRotationCryptError.badRange }
        }
        for dataIndex in 0..<dataBytes.count {
            var value = Int(dataBytes[dataIndex])
            for elementIndex in elements.indices.reversed() {
                let element = elements[elementIndex]
                if value >= element.rangeStart && value <= element.rangeEnd {
                    let rangeSpan = (element.rangeEnd - element.rangeStart) + 1
                    value -= element.rangeStart
                    value += element.amount
                    value = value % rangeSpan
                    if value < 0 {
                        value += rangeSpan
                    }
                    value += element.rangeStart
                }
            }
            dataBytes[dataIndex] = UInt8(value)
        }
        return Data(dataBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 {
            return data
        }
        for dataIndex in 0..<dataBytes.count {
            var value = Int(dataBytes[dataIndex])
            for elementIndex in elements.indices {
                let element = elements[elementIndex]
                if value >= element.rangeStart && value <= element.rangeEnd {
                    let rangeSpan = (element.rangeEnd - element.rangeStart) + 1
                    value -= element.rangeStart
                    value -= element.amount
                    value = value % rangeSpan
                    if value < 0 {
                        value += rangeSpan
                    }
                    value += element.rangeStart
                }
            }
            dataBytes[dataIndex] = UInt8(value)
        }
        return Data(dataBytes)
    }
}
