//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public typealias AnyItem = AnyHashable

public protocol ItemsLoader {
    
//    associatedtype Section: Hashable
//    associatedtype Item:
    
    
    typealias FetchItemsResult = Result<[AnyItem]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}
