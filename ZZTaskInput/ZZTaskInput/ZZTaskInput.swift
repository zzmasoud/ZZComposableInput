//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZSelectableItem: Equatable {
    var isSelected: Bool { get set }
}

public protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    
    typealias FetchItemsResult = Result<[ZZSelectableItem]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void
    
    var onSent: ZZTaskInput.SendCompletion? { get }
    func send()
    func select(section: Int, completion: @escaping FetchItemsCompletion)
}
