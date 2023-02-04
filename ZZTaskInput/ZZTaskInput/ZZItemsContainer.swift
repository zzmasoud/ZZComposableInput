//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemsContainer {
    associatedtype Item
    var items: [Item]? { get }
    var selectedItems: [Item]? { get }
    
    func select(at index: Int)
    func unselect(at index: Int)
}
