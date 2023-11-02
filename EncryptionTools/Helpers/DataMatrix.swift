//
//  DataMatrix.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum DataMatrixError: Error {
    case invalidWidth
    case invalidHeight
    case matrixTooLarge
}

class DataMatrix {
    private(set) var width: UInt8
    private(set) var height: UInt8
    var matrix: [[UInt8]]
    init(width: Int, height: Int) throws {
        if (width < 1) { throw DataMatrixError.invalidWidth }
        if (height < 1) { throw DataMatrixError.invalidHeight }
        let area = width * height
        if area > 256 { throw DataMatrixError.matrixTooLarge }
        self.width = UInt8(width)
        self.height = UInt8(height)
        var _matrix = [[UInt8]]()
        _matrix.reserveCapacity(width)
        for _ in 0..<width {
            let column = [UInt8](repeating: 0, count: height)
            _matrix.append(column)
        }
        self.matrix = _matrix
    }
    
    func dispose() {
        matrix.removeAll()
        width = 0
        height = 0
    }
    
    func swapRows(_ row1: Int, _ row2: Int) {
        if width > 0 && height > 0 && row1 >= 0 && row1 < height && row2 >= 0 && row2 < height {
            for x in 0..<Int(width) {
                let temp = matrix[x][row1]
                matrix[x][row1] = matrix[x][row2]
                matrix[x][row2] = temp
            }
        }
    }
    
    func swapCols(_ col1: Int, _ col2: Int) {
        if width > 0 && height > 0 && col1 >= 0 && col1 < width && col2 >= 0 && col2 < width {
            for y in 0..<Int(height) {
                let temp = matrix[col1][y]
                matrix[col1][y] = matrix[col2][y]
                matrix[col2][y] = temp
            }
        }
    }
    
    static func test(width: Int, height: Int) throws -> DataMatrix {
        let result = try DataMatrix(width: width, height: height)
        let area = width * height
        if width >= 1 && width <= 256 && height >= 1 && height <= 256 && area <= 256 {
            var number = 0
            var dataBytes = [UInt8]()
            for _ in 0..<area {
                dataBytes.append(UInt8(number))
                number += 1
                if number == 256 { number = 0 }
            }
            var index = 0
            for y in 0..<height {
                for x in 0..<width {
                    result.matrix[x][y] = dataBytes[index]
                    index += 1
                }
            }
        }
        return result
    }
}

extension DataMatrix: CustomStringConvertible {
    var description: String {
        var result = String()
        for y in 0..<Int(height) {
            var rowString = String("[")
            for x in 0..<Int(width) {
                var word = String(format: "%X", matrix[x][y])
                if word.count < 2 {
                    word = "0" + word
                }
                rowString.append(word)
                if x < (width - 1) {
                    rowString.append(", ")
                }
            }
            rowString.append("]")
            if y < (height - 1) {
                rowString.append("\n")
            }
            result.append(rowString)
        }
        return result
    }
}
