//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTextParser {
    associatedtype Parsed
    
    func parse(text: String) -> Parsed
}
