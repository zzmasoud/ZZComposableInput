//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTaskInput {
    typealias Data = ZZTaskModel<SectionIdentifier, ItemType.Item>
    typealias SendCompletion = (Data) -> Void
    
    associatedtype ItemType: ZZItemsContainer
    associatedtype SectionIdentifier: Hashable
    typealias FetchItemsResult = Result<ItemType, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    
    var onSent: SendCompletion? { get }
    func send()
    func select(section: SectionIdentifier, completion: @escaping FetchItemsCompletion)
}
