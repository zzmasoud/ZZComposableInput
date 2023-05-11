//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol SectionedViewDataSource: UITableViewDataSource, UICollectionViewDataSource {}

public final class UIKitSelectableCellController: SelectableCellController {
    public let dataSource: SectionedViewDataSource
    public let delegate: UITableViewDelegate?
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(id: AnyHashable, dataSource: SectionedViewDataSource, delegate: UITableViewDelegate?, dataSourcePrefetching: UITableViewDataSourcePrefetching? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.dataSourcePrefetching = dataSourcePrefetching
        super.init(id: id)
    }
}
