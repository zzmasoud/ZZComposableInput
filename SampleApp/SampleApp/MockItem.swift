//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct MockItem: Hashable {
    let id: UUID
    public let title: String
    
    public init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}
