//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

open class SelectableCellController {
    public let id: AnyHashable
    public var isSelected: (() -> (Bool))?
    
    public init(id: AnyHashable) {
        self.id = id
    }
}

extension SelectableCellController: Equatable {
    public static func == (lhs: SelectableCellController, rhs: SelectableCellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension SelectableCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
