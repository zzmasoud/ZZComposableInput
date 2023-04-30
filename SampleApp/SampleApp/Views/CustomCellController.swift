//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

protocol CustomCellPresentable {
    var title: String { get }
}

final class CustomCellController: NSObject {
    private let model: CustomCellPresentable
    private var cell: ZZSelectableCell?
    
    public init(model: CustomCellPresentable) {
        self.model = model
    }
}

extension CustomCellController: SectionedViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: ZZSelectableCell.id, for: indexPath) as? ZZSelectableCell
        cell?.textLabel?.text = model.title
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
}
