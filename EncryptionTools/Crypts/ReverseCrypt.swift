//
//  ReverseCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

struct ReverseCrypt: Cryptable {
    func encrypt(data: Data) throws -> Data {
        try proces(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try proces(data: data)
    }
    
    private func proces(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        dataBytes.reverse()
        return Data(dataBytes)
    }
}
