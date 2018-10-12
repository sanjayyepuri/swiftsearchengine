import Foundation
import Utils


let index: InvertedIndex = InvertedIndex()
let fileManager: FileManager = FileManager()
let url: URL = URL(fileURLWithPath: "/Users/sanjay/Desktop/md-Corpora")

index.indexDocuments(fileManager: fileManager, directory: url)

