//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    
    associatedtype ItemType: ZZItemsContainer
    typealias FetchItemsResult = Result<ItemType, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void
    
    var onSent: ZZTaskInput.SendCompletion? { get }
    func send()
    func select(section: Int, completion: @escaping FetchItemsCompletion)
}
