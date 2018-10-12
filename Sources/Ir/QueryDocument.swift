//
//  QueryDocument.swift
//  Ir
//
//  Created by Sanjay Yepuri on 10/12/18.
//

import Foundation

class QueryDocument: Document {
	var tokens: [String]

	init(query: String, charSet: CharacterSet) {
		tokens = query.components(separatedBy: TextDocument.charSet.inverted).filter({ $0.count > 0 })
	}

	/// Returns the next token in the document.
    override func getNextToken() -> String? {
        if hasTokens() {
        	return tokens.removeFirst().lowercased()
        }
        return nil
    }
    
    /// Returns true if there are more tokens in the document.
    override func hasTokens() -> Bool {
        return tokens.count >  0
    }
}
