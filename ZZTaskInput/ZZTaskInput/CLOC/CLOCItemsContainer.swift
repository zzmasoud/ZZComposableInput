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
    private(set) public var selectedItems: Set<Item>?
    private let selectionType: CLOCItemSelectionType
    
    public init(items: [Item]? = nil, preSelectedIndexes: [Int]? = nil, selectionType: CLOCItemSelectionType = .single) {
        self.items = items
        if let selectedItems = preSelectedIndexes?.compactMap({ items?[$0] }) {
            self.selectedItems = Set<Item>(selectedItems)
        }
        self.selectionType = selectionType
    }
    
    public func select(at index: Int) {
        guard let items = items else { return }
        let selectedItem = items[index]

        switch selectionType {
        case .single:
            selectedItems = [selectedItem]
            
        case .multiple:
            if selectedItems?.insert(selectedItem) == nil {
                selectedItems = [selectedItem]
            }
        }
    }
    
    public func unselect(at index: Int) {
        guard case .multiple = selectionType,
              let items = items else { return }
        let unselectedItem = items[index]
        
        _ = selectedItems?.remove(unselectedItem)
    }
}
