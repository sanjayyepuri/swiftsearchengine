//
//  Document.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class Document {
    let file: FileHandle
    
    init(file: FileHandle) {
        self.file = file
    }
    
    init(file: URL) throws {
        self.file = try FileHandle(forReadingFrom: file)
    }
    
    init(file: String) throws {
        self.file = try FileHandle(forReadingFrom: URL(fileURLWithPath: file))
    }
    
    func getNextToken() -> String? {
        fatalError("getNextToken must be overrided")
    }
    func hasTokens() -> Bool {
        fatalError("hasTokens must be overrided")
    }
    
    func getVector() -> MapVector {
        let vector: MapVector = MapVector()
        
        while(hasTokens()) {
            vector.increment(token: getNextToken()!, weight: 1)
        }
        
        return vector
    }
}



