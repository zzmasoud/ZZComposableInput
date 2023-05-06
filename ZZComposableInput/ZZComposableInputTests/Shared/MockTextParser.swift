//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZComposableInput

class MockTextParser<Parsed>: TextParser {
    var result: Parsed!
    private(set) var separator: Character = "\n"
    private var parseTextCalles = [String]()
    
    var parseTextCount: Int { parseTextCalles.count }
    
    func parse(text: String) -> Parsed {
        parseTextCalles.append(text)
        return result
    }
}
