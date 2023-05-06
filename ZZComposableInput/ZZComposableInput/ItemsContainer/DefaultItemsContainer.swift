//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import Foundation

public class DefaultItemsContainer<Item: AnyItem>: ItemsContainer {
    public var delegate: ItemsContainerDelegate?
    public let selectionType: ItemsContainerSelectionType
    private(set) public var items: [Item]?
    private(set) public var selectedItems: [Item]?
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
        guard let items = items, !items.isEmpty else { return }
        let newItem = items[index]

        switch selectionType {
        case .single:
            selectedItems = [newItem]
            
        case .multiple(let max):
            if selectedItems == nil {
                selectedItems = [newItem]
            } else {
                appendIfNotExist(newItem, collection: &selectedItems)
                if let removedItem = removeFirstSelectedItemIf(maxSelection: max, in: &selectedItems!) {
                    let index = indexOf(removedItem, in: items)!
                    delegate?.didDeselect(at: index)
                }
            }
        }
    }
    
    private func appendIfNotExist(_ item: Item, collection: inout [Item]?) {
        guard indexOf(item, in: collection) == nil else { return }
        collection?.append(item)
    }
    
    private func removeFirstSelectedItemIf(maxSelection max: Int, in collection: inout [Item]) -> Item? {
        guard collection.count > max else { return nil }
        return collection.remove(at: 0)
    }
}

// MARK: - Deselect

extension DefaultItemsContainer {
    public func deselect(at index: Int) {
        guard case .multiple = selectionType,
              let items = items, !items.isEmpty else { return }
        let unselectedItem = items[index]
        
        guard let foundIndex = indexOf(unselectedItem, in: selectedItems) else { return }
        selectedItems?.remove(at: foundIndex)
        nilifyIfSelectedItemsIsEmpty()
    }

    private func nilifyIfSelectedItemsIsEmpty() {
        guard selectedItems!.isEmpty else { return }
        selectedItems = nil
    }
}

