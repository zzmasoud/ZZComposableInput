//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public enum CLOCItemSelectionType {
    case single
    case multiple(max: Int)
}

public class CLOCItemsContainer: ZZItemsContainer {
    public typealias Item = String
    private(set) public var items: [Item]?
    private(set) public var selectedItems: [Item]?
    private let selectionType: CLOCItemSelectionType
    
    public init(items: [Item]? = nil, preSelectedIndexes: [Int]? = nil, selectionType: CLOCItemSelectionType = .single) {
        self.items = items
        self.selectedItems = preSelectedIndexes?.compactMap{ items?[$0] }
        self.selectionType = selectionType
    }
    
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
    
    public func unselect(at index: Int) {
        guard case .multiple = selectionType,
              let items = items else { return }
        let unselectedItem = items[index]
        
        guard let foundIndex = indexOf(unselectedItem, in: selectedItems) else { return }
        selectedItems?.remove(at: foundIndex)
        nilifyIfSelectedItemsIsEmpty()
    }
    
    private func indexOf(_ item: Item, in collection: [Item]?) -> Int? {
        return collection?.firstIndex(of: item)
    }
    
    private func nilifyIfSelectedItemsIsEmpty() {
        guard selectedItems?.isEmpty ?? false else { return }
        selectedItems = nil
    }
}
