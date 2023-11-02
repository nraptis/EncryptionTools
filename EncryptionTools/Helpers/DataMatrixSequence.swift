//
//  DataMatrixSequence.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import Foundation

enum DataMatrixSequenceError: Error {
    case overrun
    case invalidFormat
}

class DataMatrixSequence {
    private var padding: UInt8 = 0
    var matrices = [DataMatrix]()
    
    func ingest(data: Data, width: Int, height: Int) throws {
        var dataBytes = [UInt8](data)
        try ingest(dataBytes: dataBytes, width: width, height: height)
        dataBytes.removeAll()
    }
    
    func ingest(dataBytes: [UInt8], width: Int, height: Int) throws {
        dispose()
        if (width < 1) { throw DataMatrixError.invalidWidth }
        if (height < 1) { throw DataMatrixError.invalidHeight }
        let area = width * height
        if area > 256 { throw DataMatrixError.matrixTooLarge }
        var divisions = dataBytes.count / area
        var cleanlyFilled = divisions * area
        if cleanlyFilled == dataBytes.count {
            if dataBytes.count == 0 {
                padding = UInt8(area)
                divisions = 1
            } else {
                padding = 0
            }
        } else {
            divisions += 1
            cleanlyFilled += area
            padding = UInt8(cleanlyFilled - dataBytes.count)
        }
        
        for _ in 0..<divisions {
            matrices.append(try DataMatrix(width: width,
                                           height: height))
        }
        var matrixIndex = 0
        var index = 0
        while index < dataBytes.count {
            var y = 0
            while y < height && index < dataBytes.count {
                var x = 0
                while x < width && index < dataBytes.count {
                    matrices[matrixIndex].matrix[x][y] = dataBytes[index]
                    index += 1
                    x += 1
                }
                y += 1
            }
            matrixIndex += 1
        }
    }
    
    func load(data: Data) throws {
        matrices.removeAll()
        padding = 0
        var dataBytes = [UInt8](data)
        if dataBytes.count < 3 { throw DataMatrixSequenceError.invalidFormat }
        padding = dataBytes[0]
        let width = Int(dataBytes[1])
        let height = Int(dataBytes[2])
        if (width < 1) { throw DataMatrixError.invalidWidth }
        if (height < 1) { throw DataMatrixError.invalidHeight }
        let area = width * height
        if area > 256 { throw DataMatrixError.matrixTooLarge }
        let numberOfBytesRemaining = dataBytes.count - 3
        if (numberOfBytesRemaining % area) != 0 { throw DataMatrixSequenceError.invalidFormat }
        let divisions = numberOfBytesRemaining / area
        for _ in 0..<divisions {
            matrices.append(try DataMatrix(width: width,
                                           height: height))
        }
        var index = 3
        var matrixIndex = 0
        while matrixIndex < matrices.count {
            var y = 0
            while y < height {
                var x = 0
                while x < width {
                    matrices[matrixIndex].matrix[x][y] = dataBytes[index]
                    index += 1
                    x += 1
                }
                y += 1
            }
            matrixIndex += 1
        }
        dataBytes.removeAll()
    }
    
    func packAsData() -> Data {
        var dataBytes = packAsBytes()
        let result = Data(dataBytes)
        dataBytes.removeAll()
        return result
    }
    
    func packAsBytes() -> [UInt8] {
        var dataBytes = [UInt8]()
        var width = UInt8(0)
        var height = UInt8(0)
        if (matrices.count > 0) {
            width = UInt8(matrices[0].width)
            height = UInt8(matrices[0].height)
        }
        dataBytes.append(padding)
        dataBytes.append(width)
        dataBytes.append(height)
        var matrixIndex = 0
        while matrixIndex < matrices.count {
            var y = 0
            while y < height {
                var x = 0
                while x < width {
                    dataBytes.append(matrices[matrixIndex].matrix[x][y])
                    x += 1
                }
                y += 1
            }
            matrixIndex += 1
        }
        return dataBytes
    }
    
    func unpackAndDisposeAsData() -> Data {
        var dataBytes = unpackAndDisposeAsBytes()
        let result = Data(dataBytes)
        dataBytes.removeAll()
        return result
    }
    
    func unpackAndDisposeAsBytes() -> [UInt8] {
        var result = [UInt8]()
        var width = UInt8(0)
        var height = UInt8(0)
        if (matrices.count > 0) {
            width = UInt8(matrices[0].width)
            height = UInt8(matrices[0].height)
        }
        guard width > 0 && height > 0 else {
            dispose()
            return result
        }
        let ceiling = (Int(width) * Int(height) * matrices.count) - Int(padding)
        result.reserveCapacity(ceiling)
        var index = 0
        var matrixIndex = 0
        while matrixIndex < matrices.count {
            var y = 0
            while y < height && index < ceiling {
                var x = 0
                while x < width && index < ceiling {
                    result.append(matrices[matrixIndex].matrix[x][y])
                    x += 1
                    index += 1
                }
                y += 1
            }
            matrixIndex += 1
        }
        dispose()
        return result
    }
    
    func dispose() {
        var matrixIndex = 0
        while matrixIndex < matrices.count {
            matrices[matrixIndex].dispose()
            matrixIndex += 1
        }
        matrices.removeAll()
        padding = 0
    }
}
