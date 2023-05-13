//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class MockCellController: NSObject {
    private let model: MockItem
    
    init(model: MockItem) {
        self.model = model
    }
}

extension MockCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
}

final class CustomCell: UITableViewCell {
    static let id = "CustomCell"
    
    override var isSelected: Bool {
        didSet {
//            self.accessoryType = isSelected ? .checkmark : .none
        }
    }
}
