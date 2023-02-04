//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public class ZZTaskModel<Section: Hashable, Item: Equatable> {
    private(set) public var title: String
    private(set) public var description: String?
    private(set) public var selectedItems: [Section: [Item]]?
    
    init(title: String, description: String?, selectedItems: [Section: [Item]]? = nil) {
        self.title = title
        self.description = description
        self.selectedItems = selectedItems
    }
}
