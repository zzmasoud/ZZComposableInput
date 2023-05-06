//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct ResourceListViewModel {
    public let index: Int
    public let items: [any AnyItem]
    
    public init(index: Int, items: [any AnyItem]) {
        self.index = index
        self.items = items
    }
}
 
