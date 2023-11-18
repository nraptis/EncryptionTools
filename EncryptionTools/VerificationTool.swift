//
//  VerificationTool.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

class VerificationTool: ObservableObject {
    
    @Published var plainText = "0123456789ABCDEFabcdef!!bad_ABC100100204810242048_XL000R[)_76"
    @Published var encryptedText = ""
    
    private var testCipher = SplintMaskByteBlockCipher()
    
    func encrypt() {
        do {
            guard let data = plainText.data(using: .utf8) else { return }
            let encryptedData = try testCipher.encrypt(data: data)
            if let encryptedString = String(data: encryptedData, encoding: .utf8) {
                print("encrypted: \(encryptedString)")
            }
            DispatchQueue.main.async {
                self.encryptedText = encryptedData.hexString
                self.plainText = ""
            }
        } catch let error {
            print("encryption error: \(error.localizedDescription)")
        }
    }
    
    func decrypt() {
        do {
            let data = Data(hexString: encryptedText)
            let decryptedData = try testCipher.decrypt(data: data)
            if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                print("decrypted: \(decryptedString)")
            }
            DispatchQueue.main.async {
                self.plainText = String(data: decryptedData, encoding: .utf8) ?? ""
                self.encryptedText = ""
            }
        } catch let error {
            print("decryption error: \(error.localizedDescription)")
        }
    }
}
