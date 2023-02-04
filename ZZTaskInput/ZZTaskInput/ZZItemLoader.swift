//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemLoader {
    associatedtype Section
    associatedtype Item
    typealias FetchItemsResut = Result<[Item]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResut) -> Void

    func loadItems(for section: Section, completion: @escaping FetchItemsCompletion)
}
