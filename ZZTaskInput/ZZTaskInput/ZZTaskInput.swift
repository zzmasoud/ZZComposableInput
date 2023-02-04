//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTaskInput {
    associatedtype Data
    typealias SendCompletion = (Data) -> Void
    
    associatedtype SelectableItem
    associatedtype ItemType
    associatedtype Section
    typealias FetchItemsResult = Result<ItemType, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    
    var onSent: SendCompletion? { get }
    func send()
    func select(section: Section, withPreselectedItems: [SelectableItem]? , completion: @escaping FetchItemsCompletion)

}
