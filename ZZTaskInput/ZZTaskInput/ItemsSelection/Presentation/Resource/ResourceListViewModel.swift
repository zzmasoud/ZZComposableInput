//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct ResourceListViewModel {
    public let index: Int
    public let items: [NEED_TO_BE_GENERIC]
    
    public init(index: Int, items: [NEED_TO_BE_GENERIC]) {
        self.index = index
        self.items = items
    }
}
 
