//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInputiOS

final class MockCellController: NSObject {
    private let model: MockItem
    private var cell: UITableViewCell?
    
    init(model: MockItem) {
        self.model = model
    }
}

extension MockCellController: SectionedViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell()
        cell?.textLabel?.text = model.title
        return cell!
    }

    private func releaseCellForReuse() {
        cell = nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
}
