import Foundation
import Utils

do  {
    let file: FileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: "/Users/sanjay/Documents/Source/Rasware/README.md"))
    let doc = TextDocument(file: file)
    let reader = BufferedReader(file: file)
    
    
//    var str: String?
//    repeat {
//        str = reader.read()
//        print(str)
//    } while str != nil
//
    
    while doc.hasTokens() {
        print(doc.getNextToken() ?? "none")
    }
} catch {
 
}

let index: InvertedIndex = InvertedIndex()
let fileManager: FileManager = FileManager()
let url: URL = URL(fileURLWithPath: "/Users/sanjay/Desktop/md-Corpora")

index.indexDocuments(fileManager: fileManager, directory: url)

