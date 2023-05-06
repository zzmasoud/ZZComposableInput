//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

#warning("Leaking implemetion detail, using AnyObject (force only classes to confrom this protocol)")
public protocol ItemsContainer: AnyObject {
    associatedtype Item: Hashable
    
    var selectionType: ItemsContainerSelectionType { get }
    var items: [Item]? { get }
    var selectedItems: [Item]? { get }
    var allowAdding: Bool { get }
    func select(at index: Int)
    func unselect(at index: Int)
}
