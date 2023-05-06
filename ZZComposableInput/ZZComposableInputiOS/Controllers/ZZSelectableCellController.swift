//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit

public protocol SectionedViewDataSource: UITableViewDataSource, UICollectionViewDataSource {}

public final class ZZSelectableCellController {
    public let id: AnyHashable
    public let dataSource: SectionedViewDataSource
    public let delegate: UITableViewDelegate?
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    public var isSelected: (() -> (Bool))?
    
    public init(id: AnyHashable, dataSource: SectionedViewDataSource, delegate: UITableViewDelegate?, dataSourcePrefetching: UITableViewDataSourcePrefetching? = nil) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = delegate
        self.dataSourcePrefetching = dataSourcePrefetching
    }
}

extension ZZSelectableCellController: Equatable {
    public static func == (lhs: ZZSelectableCellController, rhs: ZZSelectableCellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension ZZSelectableCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
