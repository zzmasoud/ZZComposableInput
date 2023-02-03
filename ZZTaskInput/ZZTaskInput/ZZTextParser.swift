//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTextParser {
    associatedtype Parsed
    
    var separator: Character { get }
    func parse(text: String) -> Parsed
}
