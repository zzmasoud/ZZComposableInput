//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

class MockTextParser: ZZTextParser {
    
    var result = Parsed("", nil)
    private(set) var separator: Character = "\n"
    private var parseTextCalles = [String]()
    
    var parseTextCount: Int { parseTextCalles.count }
    
    func parse(text: String) -> (title: String, description: String?) {
        parseTextCalles.append(text)
        return result
    }
}
