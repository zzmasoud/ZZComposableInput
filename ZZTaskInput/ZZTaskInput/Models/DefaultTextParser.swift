//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class DefaultTextParser: TextParser {
    public typealias Parsed = (title: String, description: String?)
    
    private let separator: Character
    
    public init(separator: Character = "\n") {
        self.separator = separator
    }

    public func parse(text: String) -> Parsed {
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
