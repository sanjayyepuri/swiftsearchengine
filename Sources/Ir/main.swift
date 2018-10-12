import Foundation
import Utils


let index: InvertedIndex = InvertedIndex()
let fileManager: FileManager = FileManager()
let url: URL = URL(fileURLWithPath: "/Users/sanjay/Desktop/md-Corpora")

index.indexDocuments(fileManager: fileManager, directory: url)
print(index.docRefs)

print(index.invertedIndex)


var dict: [String: String] = [:]

if let _ = dict["hello"] {
    dict["hello"] = "steve"
} else {
    dict["hello"] = String()
    dict["hello"]!.append("steve!")
}

print(dict)

if dict["hello"] != nil {
    dict["hello"]!.append("!!!!")
} else {
    print("Hmm")
}

print(dict)
