//
//  Cipher.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

protocol Cipher {
    func encrypt(data: Data) throws -> Data
    func decrypt(data: Data) throws -> Data
}
