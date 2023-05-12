//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ItemsContainerDelegate: AnyObject {
    func didDeselect(at index: Int)
    func newItemAdded(at index: Int)
}

public protocol ItemsContainer: AnyObject {
    associatedtype Item: AnyItem
    
    var delegate: ItemsContainerDelegate? { get set }
    var selectionType: ItemsContainerSelectionType { get }
    var items: [Item] { get }
    var selectedItems: [Item]? { get }
    var allowAdding: Bool { get }
    func select(at index: Int)
    func deselect(at index: Int)
    func add(item: Item)
}
