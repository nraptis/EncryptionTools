//
//  TaylorCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum TaylorCryptError: Error {
    case malformedPassword1
    case malformedPassword2
    case emptyPassword1
    case emptyPassword2
}

struct TaylorCrypt: Cryptable {
    let password1: String
    let password2: String
    init(password1: String="apple", password2: String="banana") {
        self.password1 = password1
        self.password2 = password2
    }
    
    func encrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        try process(data: data)
    }
    
    private func process(data: Data) throws -> Data {
        var dataBytes = [UInt8](data)
        if dataBytes.count <= 0 { return data }
        guard let passwordData1 = password1.data(using: .utf8) else { throw TaylorCryptError.malformedPassword1 }
        let passwordBytes1 = [UInt8](passwordData1)
        if passwordBytes1.count <= 0 { throw TaylorCryptError.emptyPassword1 }
        guard let passwordData2 = password1.data(using: .utf8) else { throw TaylorCryptError.malformedPassword2 }
        let passwordBytes2 = [UInt8](passwordData2)
        if passwordBytes2.count <= 0 { throw TaylorCryptError.emptyPassword2 }
        var dataIndex = 0
        var passwordIndex1 = passwordBytes1.count / 2
        var passwordIndex2 = 0
        while dataIndex < dataBytes.count {
            dataBytes[dataIndex] ^= passwordBytes1[passwordIndex1]
            dataBytes[dataIndex] ^= passwordBytes2[passwordIndex2]
            dataIndex += 1
            passwordIndex1 += 1
            if passwordIndex1 == passwordBytes1.count { passwordIndex1 = 0 }
            passwordIndex2 = (passwordIndex2 + passwordIndex1 + 2) % passwordBytes2.count
        }
        return Data(dataBytes)
    }
}
