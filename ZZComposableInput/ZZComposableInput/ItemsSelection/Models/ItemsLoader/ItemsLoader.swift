//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ItemsLoader {
    associatedtype Item: AnyItem
    
    typealias FetchItemsResult = Result<[Item]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}
