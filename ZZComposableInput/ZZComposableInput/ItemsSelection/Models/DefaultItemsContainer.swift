//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import Foundation

public enum ItemsContainerSelectionType: Hashable {
    case single
    case multiple(max: Int)
}

public class DefaultItemsContainer: ItemsContainer {
    public typealias Item = AnyItem
    
    private(set) public var items: [Item]?
    private(set) public var selectedItems: [Item]?
    public let selectionType: ItemsContainerSelectionType
    public let allowAdding: Bool
    
    public convenience init(items: [Item]? = nil, preSelectedIndexes: [Int]? = nil, selectionType: ItemsContainerSelectionType, allowAdding: Bool) {
        self.init(
            items: items,
            preSelectedItems: preSelectedIndexes?.compactMap { items?[$0] },
            selectionType: selectionType,
            allowAdding: allowAdding
        )
    }
    
    public init(items: [Item]? = nil, preSelectedItems: [Item]? = nil, selectionType: ItemsContainerSelectionType, allowAdding: Bool) {
        self.items = items
        self.selectedItems = preSelectedItems
        self.selectionType = selectionType
        self.allowAdding = allowAdding
    }
        
    private func indexOf(_ item: Item, in collection: [Item]?) -> Int? {
        return collection?.firstIndex(of: item)
    }
}

// MARK: - Select

extension DefaultItemsContainer {
    public func select(at index: Int) {
        guard let items = items else { return }
        let newItem = items[index]

        switch selectionType {
        case .single:
            selectedItems = [newItem]
            
        case .multiple(let max):
            if selectedItems == nil {
                selectedItems = [newItem]
            } else {
                appendIfNotExist(newItem, collection: &selectedItems)
                removeFirstSelectedItemIf(maxSelection: max, in: &selectedItems)
            }
        }
    }
    
    private func appendIfNotExist(_ item: Item, collection: inout [Item]?) {
        guard indexOf(item, in: collection) == nil else { return }
        collection?.append(item)
    }
    
    private func removeFirstSelectedItemIf(maxSelection max: Int, in collection: inout [Item]?) {
        guard (collection?.count ?? 0) > max else { return }
        collection?.remove(at: 0)
    }
}

// MARK: - Unselect

extension DefaultItemsContainer {
    public func unselect(at index: Int) {
        guard case .multiple = selectionType,
              let items = items else { return }
        let unselectedItem = items[index]
        
        guard let foundIndex = indexOf(unselectedItem, in: selectedItems) else { return }
        selectedItems?.remove(at: foundIndex)
        nilifyIfSelectedItemsIsEmpty()
    }

    private func nilifyIfSelectedItemsIsEmpty() {
        guard selectedItems?.isEmpty ?? false else { return }
        selectedItems = nil
    }
}

