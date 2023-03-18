//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

public final class ZZSelectableCellController {
    public let id: AnyHashable
    public let dataSource: UITableViewDataSource
    public let delegate: UITableViewDelegate?
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    public let isSelected: (() -> Bool)
    
    init(id: AnyHashable, dataSource: UITableViewDataSource, delegate: UITableViewDelegate?, dataSourcePrefetching: UITableViewDataSourcePrefetching? = nil, isSelected: @escaping () -> Bool) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = delegate
        self.dataSourcePrefetching = dataSourcePrefetching
        self.isSelected = isSelected
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
