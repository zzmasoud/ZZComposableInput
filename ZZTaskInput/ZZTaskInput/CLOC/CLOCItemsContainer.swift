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
        self.selectedItems = preSelectedIndexes?.compactMap { items?[$0] }
        self.selectionType = selectionType
    }
    
    public func select(at index: Int) {
        guard let items = items else {
            return
        }
        let selectedItem = items[index]

        switch selectionType {
        case .single:
            selectedItems = [selectedItem]
            
        case .multiple:
            if selectedItems?.append(selectedItem) == nil {
                selectedItems = [selectedItem]
            }
        }
    }
    
    public func unselect(at index: Int) {
        
    }
}
