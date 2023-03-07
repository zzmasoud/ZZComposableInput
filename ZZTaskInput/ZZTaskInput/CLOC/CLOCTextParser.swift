//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class CLOCTextParser<Output> {
    private let separator: Character
    
    public init(separator: Character = "\n") {
        self.separator = separator
    }
}

extension CLOCTextParser: ZZTextParser where Output == (title: String, description: String?) {
    public func parse(text: String) -> Output {
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
