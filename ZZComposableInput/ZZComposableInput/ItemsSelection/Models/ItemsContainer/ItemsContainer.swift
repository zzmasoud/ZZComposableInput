//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ItemsContainer: AnyObject {
    associatedtype Item
    
    var selectionType: ItemsContainerSelectionType { get }
    var items: [Item]? { get }
    var selectedItems: [Item]? { get }
    var allowAdding: Bool { get }
    func select(at index: Int)
    func unselect(at index: Int)
}
