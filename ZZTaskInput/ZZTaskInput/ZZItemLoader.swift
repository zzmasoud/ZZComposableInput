//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemLoader {
    associatedtype Item
    typealias FetchItemsResut = Result<[Item]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResut) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}
