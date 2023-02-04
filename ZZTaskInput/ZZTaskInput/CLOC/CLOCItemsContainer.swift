//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct CLOCItemsContainer: ZZItemsContainer {
    public typealias Item = String
    private(set) public var items: [Item]?
    private(set) public var selectedItems: [Item]?
    
    public init(items: [Item]? = nil, preSelectedIndexes: [Int]? = nil) {
        self.items = items
        self.selectedItems = preSelectedIndexes?.compactMap { items?[$0] }
    }
}
