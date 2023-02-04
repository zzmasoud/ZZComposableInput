//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZItemsContainer {
    associatedtype Item
    var items: [Item]? { get set }
}
