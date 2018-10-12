//
//  Document.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class Document {
    
    /// The FileHandle for the file to be tokenized.
    let file: FileHandle
    
    /// Constructor that intializes the class with a Filehandler.
    ///
    /// - Parameters:
    ///     - file: The FileHandle for the file to be read.
    init(file: FileHandle) {
        self.file = file
    }
    
    /// Constructor that intializes the class with a URL
    ///
    /// - Parameters:
    ///     - file: The URL for the file to be read.
    init(file: URL) throws {
        self.file = try FileHandle(forReadingFrom: file)
    }
    
    /// Constructor that intializes the class with a path String.
    ///
    /// - Parameters:
    ///     - file: The String representing the url of the file to be read.
    init(file: String) throws {
        self.file = try FileHandle(forReadingFrom: URL(fileURLWithPath: file))
    }
    
    /// Returns the next token in the document.
    func getNextToken() -> String? {
        fatalError("getNextToken must be overrided")
    }
    
    /// Returns true if there are more tokens in the document.
    func hasTokens() -> Bool {
        fatalError("hasTokens must be overrided")
    }
    
    /// Returns the MapVector representation of tokens in the document. 
    func getVector() -> MapVector {
        let vector: MapVector = MapVector()
        
        while(hasTokens()) {
            vector.increment(token: getNextToken()!, weight: 1)
        }
        
        return vector
    }
}



