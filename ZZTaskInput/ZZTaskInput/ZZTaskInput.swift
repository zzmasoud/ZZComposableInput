//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    
    typealias SelectableItem = Any
    typealias FetchItemsResut = Result<[SelectableItem], Error>
    typealias FetchItemsCompletion = (FetchItemsResut) -> Void
    
    var onSent: ZZTaskInput.SendCompletion? { get }
    func send()
}
