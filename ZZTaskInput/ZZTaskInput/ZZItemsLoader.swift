//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

#warning("this model is used to fix associatedtype of `ZZItemsLoader` but later this will be removed and the protocol become fully generic")
public struct NEED_TO_BE_GENERIC: Hashable {
    public let id: UUID
    public let title: String
    
    public init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}


public protocol ZZItemsLoader {
    
//    associatedtype Section: Hashable
//    associatedtype Item:
    
    
    typealias FetchItemsResult = Result<[NEED_TO_BE_GENERIC]?, Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}
