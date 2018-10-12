//
//  Document.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class Document {
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



