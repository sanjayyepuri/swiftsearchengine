//
//  invertedindex.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation


class InvertedIndex {
    var invertedIndex: [String : PostingList] = [:]
    var docRefs: [DocumentReference] = []
    
    
    func indexDocuments(fileManager: FileManager, directory: URL) -> Void {
        print(directory.path)
        do {
            let files = try fileManager.contentsOfDirectory(atPath: directory.path)
            for file in files {
                do {
                    let url: URL = directory.appendingPathComponent(file)
                    
                    print("Indexing \(file)")
                    try indexDocument(doc: TextDocument(file: FileHandle(forReadingFrom: url)))
                   
                } catch {
                    print("Error indexing \(file): \(error)")
                }
            }
        } catch {
            print("Error indexing \(directory.path): \(error)")
            return
        }
        
        // compute tf/idf for each token
        for (token, postingList) in invertedIndex {
            let idf: Double = log(Double(docRefs.count)/Double(postingList.postings.count))
            
            for posting in postingList.postings {
                posting.documentRef.length += pow(idf * Double(posting.tf), 2)
                posting.documentRef.vector.vector[token] = Double(posting.tf) * idf
            }
        }
        
        // compute length for each token
        for doc in docRefs {
            doc.length = sqrt(doc.length)
        }
        
    }
    
    /// Indexes the document into the invertedIndex
    ///
    /// - Parameters
    ///     - doc: The document to be indexed. 
    func indexDocument(doc: Document) -> Void {
        let vector = doc.getVector()
        let docRef = DocumentReference(document: doc, vector: vector)
        docRefs.append(docRef)
        
        // Index each token.
        for (token, weight) in vector.vector {
            if let posting = invertedIndex[token] {
                posting.append(Posting(documentRef: docRef , tf: Int(weight)))
            }
        }
    }
}

class DocumentReference {
    let doc: Document
    let vector: MapVector
    var length: Double = 0;
    
    init(document: Document, vector: MapVector) {
        self.doc = document
        self.vector = vector
    }
}

