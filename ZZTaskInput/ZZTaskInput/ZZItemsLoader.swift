//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemsLoader {
    associatedtype Section: Hashable
    associatedtype Item
    typealias FetchItemsResult = Result<[Item]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Section, completion: @escaping FetchItemsCompletion)
}
