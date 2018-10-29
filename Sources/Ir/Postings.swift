//
//  Postings.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class PostingList: CustomStringConvertible {
    var postings: [Posting] = []
    var idf: Double = 0
    
    public var description : String { return "\(postings)"}
    
    func append(posting: Posting) {
        postings.append(posting)
    }
}

class Posting: CustomStringConvertible{
    var documentRef: DocumentReference
    var tf: Int = 0
    
    public var description : String { return String(tf) }
    
    init(documentRef: DocumentReference, tf: Int) {
        self.documentRef = documentRef
        self.tf = tf
    }
}
