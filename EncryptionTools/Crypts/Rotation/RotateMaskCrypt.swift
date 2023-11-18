//
//  RotateMaskCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

//11110000 (F0) (240)
//00001111 (0F) (15)
//11000011 (C3) (195)
//00111100 (3C) (60)
//11001100 (CC) (204)
//00110011 (33) (51)
//10011001 (99) (153)
//10101010 (AA) (170)
//01010101 (55) (85)
//10111101 (BD) 189
//11001111 (CF) 207
//11110011 (F3) 243
//11011011 (DB) 219
//10101111 (AF) 175
//11110101 (F5) 245

struct RotateMaskCrypt: Cryptable {
    let mask: UInt8
    let shift: Int
    init(mask: UInt8 = 60, shift: Int = 1) {
        self.mask = mask
        self.shift = shift
    }
    
    func encrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        var dataBytesRotated = [UInt8]()
        dataBytesRotated.reserveCapacity(dataBytes.count)
        var rotation = shift % dataBytes.count
        if rotation < 0 { rotation += dataBytes.count }
        var index = rotation
        while index < dataBytes.count {
            dataBytesRotated.append(dataBytes[index])
            index += 1
        }
        index = 0
        while index < rotation {
            dataBytesRotated.append(dataBytes[index])
            index += 1
        }
        let antimask = ~mask
        for byteIndex in dataBytes.indices {
            dataBytes[byteIndex] &= antimask
            dataBytes[byteIndex] |= (dataBytesRotated[byteIndex] & mask)
        }
        return Data(dataBytes)
    }
    
    func decrypt(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        var dataBytesRotated = [UInt8]()
        dataBytesRotated.reserveCapacity(dataBytes.count)
        var rotation = (-shift) % dataBytes.count
        if rotation < 0 { rotation += dataBytes.count }
        var index = rotation
        while index < dataBytes.count {
            dataBytesRotated.append(dataBytes[index])
            index += 1
        }
        index = 0
        while index < rotation {
            dataBytesRotated.append(dataBytes[index])
            index += 1
        }
        let antimask = ~mask
        for byteIndex in dataBytes.indices {
            dataBytes[byteIndex] &= antimask
            dataBytes[byteIndex] |= (dataBytesRotated[byteIndex] & mask)
        }
        return Data(dataBytes)
    }
}
