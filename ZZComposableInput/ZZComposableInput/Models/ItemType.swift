//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public typealias AnyItem = ItemType

public protocol ItemType: Hashable {
    var title: String { get }
}
