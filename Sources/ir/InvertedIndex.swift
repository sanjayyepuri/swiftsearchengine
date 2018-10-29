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
                    try indexDocument(doc: TextDocument(file: url))
                   
                } catch {
                    print("Error indexing \(file): \(error)")
                }
            }
        } catch {
            print("Error indexing \(directory.path): \(error)")
            return
        }
        
        // compute tf/idf for each token
        for (token, postings) in invertedIndex {
            let idf: Double = log(Double(docRefs.count)/Double(postings.postings.count))
            
            postings.idf = idf;
            
            for posting in postings.postings {
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
    func indexDocument(doc: TextDocument) -> Void {
        let vector = doc.getVector()
        let docRef = DocumentReference(document: doc, vector: vector)
        
        // Add the document to the list of indexed documents
        docRefs.append(docRef)
        
        // Index each token.
        for (token, weight) in vector.vector {
            // Create a posting object for the document. The term frequency
            // is the weight of the term in the HMV.
            let newPosting = Posting(documentRef: docRef , tf: Int(weight))
            // Add the documents to the posting list.
            if let posting = invertedIndex[token] {
                posting.append(posting: newPosting)
            } else {
                invertedIndex[token] = PostingList()
                invertedIndex[token]!.append(posting: newPosting)
            }
        }
    }
    
    func queryIndex(query: String) -> [DocumentReference]{
        let queryDoc = QueryDocument(query: query, charSet: TextDocument.charSet)
        let queryVector = queryDoc.getVector()

        var retrievalDict: [DocumentReference: Double] = [:]
        
        // Create a list of possible retrievals
        for var entry in queryVector.vector {
            if let postings = invertedIndex[entry.key] {
                // Compute the query vector's weights.
                entry.value = entry.value * postings.idf
                // Increment the weight of all the matching documents and
                // iteratively calculate the dot product.
                for posting in postings.postings {
                    if var weight = retrievalDict[posting.documentRef] {
                        weight += entry.value * Double(posting.tf)
                    } else {
                        retrievalDict[posting.documentRef] = entry.value * Double(posting.tf)
                    }
                }
            } else { entry.value = 0 }
        }
        
        // Normalize all the scores of the retrieved documents.
        // (cosine similarity)
        let l = queryVector.length
        for (docRef, var weight) in retrievalDict {
            let y = docRef.length
            weight = weight/(l*y)
        }
        
        // sort the retrievals and create a list of document references ow
        return retrievalDict.sorted(by: {$0.value < $1.value}).map({ return $0.key })
    }
}

class DocumentReference: Hashable, Equatable {
    let doc: TextDocument
    let vector: MapVector
    var length: Double = 0;
    
    init(document: TextDocument, vector: MapVector) {
        self.doc = document
        self.vector = vector
    }
    
    static func == (lhs: DocumentReference, rhs: DocumentReference) -> Bool {
        return rhs.doc.file == lhs.doc.file
    }
    
    var hashValue: Int {
        return doc.file.hashValue
    }
}

