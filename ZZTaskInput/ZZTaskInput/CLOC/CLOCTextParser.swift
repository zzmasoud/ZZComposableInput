//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class CLOCTextParser: ZZTextParser {
    public typealias Parsed = (title: String, description: String?)
    public let separator: Character = "\n"
    
    public init() {}
    
    public func parse(text: String) -> (title: String, description: String?) {
        var result: (String, String?) = ("", nil)
        
        let components = text.split(separator: separator)
        
        if let title = components.first {
            result.0 = String(title)
        }
        
        if components.count > 1 {
            result.1 =
            String(
                components[1..<components.count]
                .joined(separator: "\n")
            )
            .trimmingCharacters(in: .whitespaces)
        }
        
        return result
    }
}
