//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemsContainer {
    associatedtype Item: Hashable
    var items: [Item]? { get }
    var selectedItems: Set<Item>? { get }
    
    func select(at index: Int)
    func unselect(at index: Int)
}
