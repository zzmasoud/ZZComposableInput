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
            if var selectedItems = selectedItems {
                guard selectedItems.firstIndex(of: newItem) == nil else { return }
                selectedItems.append(newItem)
                if selectedItems.count > max {
                    selectedItems.remove(at: 0)
                }
                self.selectedItems = selectedItems
            } else {
                selectedItems = [newItem]
            }
        }
    }
    
    public func unselect(at index: Int) {
        guard case .multiple = selectionType,
              let items = items else { return }
        let unselectedItem = items[index]
        
        guard let foundIndex = selectedItems?.firstIndex(of: unselectedItem) else { return }
        selectedItems?.remove(at: foundIndex)
        nilifyIfSelectedItemsIsEmpty()
    }
    
    private func nilifyIfSelectedItemsIsEmpty() {
        guard selectedItems?.isEmpty ?? false else { return }
        selectedItems = nil
    }
}
