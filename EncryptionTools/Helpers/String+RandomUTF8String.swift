//
//  String+RandomUTF8String.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

extension String {
    static func randomUTF8String(length: Int) -> String {
        let valid: [Character] = ["\0", "\u{01}", "\u{02}", "\u{03}", "\u{04}", "\u{05}", "\u{06}", "\u{07}", "\u{08}",
                                  "\t", "\n", "\u{0B}", "\u{0C}", "\r", "\u{0E}", "\u{0F}", "\u{10}", "\u{11}", "\u{12}",
                                  "\u{13}", "\u{14}", "\u{15}", "\u{16}", "\u{17}", "\u{18}", "\u{19}", "\u{1A}", "\u{1B}",
                                  "\u{1C}", "\u{1D}", "\u{1E}", "\u{1F}", " ", "!", "\"", "#", "$", "%", "&", "\'", "(", ")",
                                  "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@",
                                  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                                  "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`",
                                  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                                  "w", "x", "y", "z", "{", "|", "}", "~", "\u{7F}", "�"]
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
