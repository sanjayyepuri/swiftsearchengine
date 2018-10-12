//
//  BufferedReader.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class BufferedReader {
    let file: FileHandle
    let bufferSize: Int
    let delimiter: Data
    let encoding: String.Encoding
    
    var buffer: Data
    var atEOF: Bool = false
    
    init(file: FileHandle, bufferSize: Int = 4096, delimiter: String = "\n", encoding: String.Encoding = .utf8) {
        self.file = file
        self.bufferSize = bufferSize
        self.encoding = encoding
        self.delimiter = delimiter.data(using: encoding)!
        self.buffer = Data(capacity: 4096)
    }
    
    func fillBuffer() -> Bool {
        if atEOF { return false }
        
        if buffer.count < bufferSize {
            let size = bufferSize - buffer.count;
            let data = file.readData(ofLength: size)
            if data.count == 0 {
                atEOF = true
                return false
            }
            
            buffer.append(data)
            return true
        }
        
        return true
    }
    
    func read() -> String? {
        var str: String = ""
        
        repeat {
            if let range = buffer.range(of: delimiter, options: [], in: buffer.startIndex..<buffer.endIndex) {
                let data = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                str.write(String(data: data, encoding: encoding)!)
                buffer.removeSubrange(buffer.startIndex...range.lowerBound)
                return str
            } else {
                str.write(String(data: buffer, encoding: encoding)!)
                buffer.removeAll()
                if !fillBuffer() && buffer.count == 0 {
                    if str.count > 0 {
                        return str
                    }
                    return nil
                }
            }
        } while true
    }
}

