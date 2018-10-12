//
//  TextDocument.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation


class TextDocument: Document {
    let bufReader: BufferedReader
    var currentLine: [String] = []
    var isEmpty: Bool = false
    
    static let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMONOPQRSTUVWXYZ01234567890")
    
 
    override init(file: FileHandle) {
        
        
        bufReader = BufferedReader(file: file)
        super.init(file: file)
    }
    
    override func getNextToken() -> String? {
        while currentLine.isEmpty {
            if let str = bufReader.read() {
                
                currentLine = str.components(separatedBy: TextDocument.charSet.inverted)
            } else {
                isEmpty = true
                return nil
            }
        }
        
        let str = currentLine.removeFirst().trimmingCharacters(in: TextDocument.charSet.inverted)
        if str.count == 0{
            return getNextToken()
        }
        return str
    }
    
    override func hasTokens() -> Bool {
        if isEmpty { return false }
        
        while currentLine.isEmpty {
            if let str = bufReader.read() {
                currentLine = str.split(separator: " ").map(String.init)
            } else {
                isEmpty = true
                return false
            }
        }
        return true
    }

}
