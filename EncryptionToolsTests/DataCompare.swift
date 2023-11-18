//
//  DataCompare.swift
//  EncryptionToolsTests
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation
import XCTest
@testable import EncryptionTools

struct DataCompare {
    
    static func execute(crypt: some Cipher, datas: [Data], name: String) -> Int {
        var loops = 0
        for data in datas {
            execute(crypt: crypt, data: data, name: name)
            loops += 1
        }
        return loops
    }
    
    static func execute(crypt: some Cipher, data: Data, name: String) {

        guard let encrypted = try? crypt.encrypt(data: data) else {
            XCTFail("\(name) could not encrypt data (\(data.count) bytes)")
            if let string = String(data: data, encoding: .utf8) {
                print("\(name) data string: \(string)")
            }
            print("\(name) data bytes: \([UInt8](data))")
            return
        }
        
        guard let decrypted = try? crypt.decrypt(data: encrypted) else {
            XCTFail("\(name) could not decrypt data (\(data.count) bytes) (\(encrypted.count) bytes encrypted)")
            if let string = String(data: data, encoding: .utf8) {
                print("\(name) data string: \(string)")
            }
            print("\(name) data bytes: \([UInt8](data))")
            if let string = String(data: encrypted, encoding: .utf8) {
                print("\(name) encrypted string: \(string)")
            }
            print("\(name) encrypted bytes: \([UInt8](encrypted))")
            return
        }
        
        if (decrypted != data) {
            XCTFail("\(name) decrypted mismatch (\(data.count) bytes) (\(encrypted.count) bytes encrypted) (\(decrypted.count) bytes decrypted)")
            if let string = String(data: data, encoding: .utf8) {
                print("\(name) data string: \(string)")
            }
            print("\(name) data bytes: \([UInt8](data))")
            if let string = String(data: encrypted, encoding: .utf8) {
                print("\(name) encrypted string: \(string)")
            }
            print("\(name) encrypted bytes: \([UInt8](encrypted))")
            
            if let string = String(data: decrypted, encoding: .utf8) {
                print("\(name) decrypted string: \(string)")
            }
            print("\(name) decrypted bytes: \([UInt8](decrypted))")
            return
        }
    }
}
