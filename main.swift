import Foundation

do  {
    let file: FileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: "/Users/sanjay/Documents/Source/Rasware/README.md"))
    let doc = TextDocument(file: file)
    let reader = BufferedReader(file: file)
    
    
    var str: String?
    repeat {
        str = reader.read()
        print(str)
    } while str != nil
    
    
//    while doc.hasTokens() {
//        print(doc.getNextToken() ?? "none")
//    }
} catch {

}




let str: String = "https://developer.apple.com/docume.ntation/foundation/characterset/1779632-alphanumerics"
print(str.components(separatedBy: TextDocument.charSet.inverted))