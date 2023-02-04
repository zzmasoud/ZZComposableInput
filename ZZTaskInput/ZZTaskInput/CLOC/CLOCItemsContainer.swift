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
        if let items = items {
            selectedItems = [items[index]]
        }
    }
    
    public func unselect(at index: Int) {
        
    }
}
