//
//  AESCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation
import CryptoKit

enum AESCipherError: Error {
    case failedToSealData
}

struct AESCipher: Cipher {
    var key: String
    var nonce: String
    init(key: String = "FAFE43D075BF8D693B5009785FA0C20BEEFD9CB04B1D18E7E33B7BDFE13DB87B", nonce: String = "F0D1F5D36937A5CBD62DF00D") {
        self.key = key
        self.nonce = nonce
    }
    
    func encrypt(data: Data) throws -> Data {
        let keyData = Data(hexString: key)
        let symmetricKey = SymmetricKey(data: keyData)
        let nonceData = Data(hexString: nonce)
        let nonceObject = try AES.GCM.Nonce(data: nonceData)
        let sealedData = try AES.GCM.seal(data, using: symmetricKey, nonce: nonceObject)
        if let encryptedData = sealedData.combined {
            return encryptedData
        } else {
            throw AESCipherError.failedToSealData
        }
    }
    
    func decrypt(data: Data) throws -> Data {
        let keyData = Data(hexString: key)
        let symmetricKey = SymmetricKey(data: keyData)
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        return decryptedData
    }
}
