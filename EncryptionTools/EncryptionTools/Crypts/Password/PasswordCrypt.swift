//
//  PasswordCrypt.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum PasswordCryptError: Error {
    case malformedPassword
    case emptyPassword
}

struct PasswordCrypt: Cryptable {
    let password: String
    init(password: String = "catdogCATDOGdogcatFROGpigMOOSE") {
        self.password = password
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
        guard let passwordData = password.data(using: .utf8) else { throw PasswordCryptError.malformedPassword }
        let passwordBytes = [UInt8](passwordData)
        if passwordBytes.count <= 0 { throw PasswordCryptError.emptyPassword }
        var dataIndex = 0
        var passwordIndex = passwordBytes.count / 2
        while dataIndex < dataBytes.count {
            dataBytes[dataIndex] ^= passwordBytes[passwordIndex]
            dataIndex += 1
            passwordIndex += 1
            if passwordIndex == passwordBytes.count {
                passwordIndex = 0
            }
        }
        return Data(dataBytes)
    }
}
