//
//  Postings.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class PostingList {
    var postings: [Posting] = []
}

class Posting {
    var documentRef: DocumentReference
    var tf: Int = 0
    
    init(documentRef: DocumentReference, tf: Int) {
        self.documentRef = documentRef
        self.tf = tf
    }
}
