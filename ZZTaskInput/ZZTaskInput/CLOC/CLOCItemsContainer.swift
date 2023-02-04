//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct CLOCItemsContainer: ZZItemsContainer {
    public typealias Item = String
    public var items: [String]?
    
    public init(items: [String]? = nil) {
        self.items = items
    }
}
