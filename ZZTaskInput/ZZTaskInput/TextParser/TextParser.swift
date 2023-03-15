//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol TextParser {
    associatedtype Parsed
    
    func parse(text: String) -> Parsed
}
