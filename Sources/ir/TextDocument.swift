//
//  TextDocument.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation
import Utils


class TextDocument: Document {
    /// The BufferedReader used to read the file line by line.
    let bufReader: BufferedReader
    
    /// The tokens that are left in the line that had been read last
    var currentLine: [String] = []
    
    /// Is true if there are no more tokens in the file.
    var isEmpty: Bool = false
    
    /// The Character set that contains the tokens that should not be used to delimit tokens.
    static let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890")
    
    /// Constructs the TextDocument with the BufferedReader used to parse the file.
    ///
    /// - Parameters:
    ///     - file: The FileHandle for the file to be read.
    override init(file: FileHandle) {
        bufReader = BufferedReader(file: file)
        super.init(file: file)
    }

    
    override func getNextToken() -> String? {
        while currentLine.isEmpty {
            if let str = bufReader.read() {
                currentLine = str.components(separatedBy: TextDocument.charSet.inverted).filter({ $0.count > 0 })
            } else {
                isEmpty = true
                return nil
            }
        }
        
        let str = currentLine.removeFirst()
        return str
    }
    
    override func hasTokens() -> Bool {
        if isEmpty { return false }
        
        while currentLine.isEmpty {
            if let str = bufReader.read() {
                currentLine = str.components(separatedBy: TextDocument.charSet.inverted).filter({ $0.count > 0 })
            } else {
                isEmpty = true
                return false
            }
        }
        return true
    }

}
