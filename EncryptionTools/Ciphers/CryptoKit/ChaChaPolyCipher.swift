//
//  ChaChaPolyCipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation
import CryptoKit

struct ChaChaPolyCipher: Cipher {
    var key: String
    var nonce: String
    init(key: String = "CA8771118EDB1E25A416E7CBCA3E071FEEFEE4838FB1103CFB10D375FB188EE9", nonce: String = "99B88F6F9FBEEE15FFEEE2FA") {
        self.key = key
        self.nonce = nonce
    }
    
    func encrypt(data: Data) throws -> Data {
        let keyData = Data(hexString: key)
        let symmetricKey = SymmetricKey(data: keyData)
        let nonceData = Data(hexString: nonce)
        let nonceObject = try ChaChaPoly.Nonce(data: nonceData)
        let sealedData = try ChaChaPoly.seal(data, using: symmetricKey, nonce: nonceObject)
        let encryptedData = sealedData.combined
        return encryptedData
    }
    
    func decrypt(data: Data) throws -> Data {
        let keyData = Data(hexString: key)
        let symmetricKey = SymmetricKey(data: keyData)
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
        return decryptedData
    }
}
