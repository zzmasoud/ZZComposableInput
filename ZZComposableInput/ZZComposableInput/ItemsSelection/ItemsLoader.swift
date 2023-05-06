//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

#warning("#1 - using AnyHashable just to make things easier!")
public typealias AnyItem = AnyHashable

public protocol ItemsLoader {
    
//    associatedtype Section: Hashable
//    associatedtype Item:
    
    typealias FetchItemsResult = Result<[AnyItem]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}
