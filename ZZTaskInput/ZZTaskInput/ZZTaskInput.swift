//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZSelectableItem {
    var isSelected: Bool { get set }
}

public protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    
    typealias FetchItemsResut = Result<[ZZSelectableItem]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResut) -> Void
    
    var onSent: ZZTaskInput.SendCompletion? { get }
    func send()
    func select(section: Int, completion: @escaping FetchItemsCompletion)
}
