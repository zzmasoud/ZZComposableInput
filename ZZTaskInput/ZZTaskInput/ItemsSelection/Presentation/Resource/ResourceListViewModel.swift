//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct ResourceListViewModel {
    public let index: Int
    public let items: [AnyItem]
    
    public init(index: Int, items: [AnyItem]) {
        self.index = index
        self.items = items
    }
}
 
