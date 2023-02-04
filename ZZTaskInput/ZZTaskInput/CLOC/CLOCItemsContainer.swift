//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct CLOCItemsContainer: ZZItemsContainer {
    public typealias Item = String
    private(set) public var items: [String]?
    private(set) public var selectedItems: [String]?
    
    public init(items: [String]? = nil) {
        self.items = items
    }
}
