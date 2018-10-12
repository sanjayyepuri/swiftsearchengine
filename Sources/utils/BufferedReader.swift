//
//  BufferedReader.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

public class BufferedReader {
    /// The file to be read.
    let file: FileHandle
    
    /// The size of the buffer.
    let bufferSize: Int
    
    /// The delimiter used to seprate tokens kept as a Data object.
    let delimiter: Data
    
    /// The encoding of the current file.
    let encoding: String.Encoding
    
    /// The current Data buffer.
    var buffer: Data
    
    /// A Bool that stores whether the end of the file has been reached (The entire document has been read).
    var atEOF: Bool = false
    
    /// Constructs a Buffered Reader with the given file handle.
    /// - Parameters:
    ///     - file: The FileHandle who should be read.
    ///     - bufferSize: The length of the buffer to be kept.
    ///     - delimeter: The character to seperate tokens.
    ///     - encoding: The String.Encoding of the file.
    public init(file: FileHandle, bufferSize: Int = 4096, delimiter: String = "\n", encoding: String.Encoding = .utf8) {
        self.file = file
        self.bufferSize = bufferSize
        self.encoding = encoding
        self.delimiter = delimiter.data(using: encoding)!
        self.buffer = Data(capacity: 4096)
    }
    
    /// A helper function that will try to fill the entire buffer.
    ///
    /// - Returns: Whether bytes have been added to the buffer.
    private func fillBuffer() -> Bool {
        // If the file has been read, there are no more bytes to add
        if atEOF { return false }
        
        /// Fill the empty space of the buffer.
        if buffer.count < bufferSize {
            let size = bufferSize - buffer.count;
            let data = file.readData(ofLength: size)
            // If data's size is 0 there are no more bytes to be read
            if data.count == 0 {
                atEOF = true
                return false
            }
            
            buffer.append(data)
            return true
        }
        
        return true
    }
    
    /// This function returns the next token from the file or nil of there are no more tokens to be read.
    ///
    /// - Returns: The next token from the file or nil of the end of the file is reached 
    public func read() -> String? {
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
                if !fillBuffer() {
                    if str.count > 0 {
                        return str
                    }
                    return nil
                }
            }
        } while true
    }
}

