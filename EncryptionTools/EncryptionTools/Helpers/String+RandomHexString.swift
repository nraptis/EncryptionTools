//
//  String+RandomHexString.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

extension String {
    static func randomHexString(length: Int) -> String {
        let valid: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        var array = [Character]()
        var index = 0
        while index < length {
            let letter = valid[Int.random(in: 0..<valid.count)]
            array.append(letter)
            index += 1
        }
        return String(array)
    }
}
