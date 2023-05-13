//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final class MockListView: NSObject, ResourceListViewProtocol {
    private var tableView: UITableView
    var onSelection: ((Int) -> Void)
    var onDeselection: ((Int) -> Void)
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
        self.onSelection = { _ in }
        self.onDeselection = { _ in }
    }

    var view: UITableView { tableView }

    private var cellControllers = [SelectableCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func reloadData(with newCellControllers: [SelectableCellController]) {
        tableView.dataSource = self
        tableView.delegate = self

        cellControllers = newCellControllers
    }
        
    func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
        
    func deselect(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func allowAddNew(_ isOn: Bool) {}
}


extension MockListView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath)
        if let mockId = controller.id as? MockCellController {
            cell = mockId.tableView(tableView, cellForRowAt: indexPath)
        }
        let isSelected = controller.isSelected?() ?? false
        if isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}
