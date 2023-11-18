//
//  InvertCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct InvertCrypt: Cryptable {
    func encrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    private func process(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        for index in dataBytes.indices {
            dataBytes[index] = ~dataBytes[index]
        }
        return Data(dataBytes)
    }
}
