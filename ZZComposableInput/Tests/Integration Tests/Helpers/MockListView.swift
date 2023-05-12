//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final class MockListView: NSObject, ResourceListViewProtocol {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    var view: UITableView { tableView}
    
    var onSelection: ((Int) -> Void)
    var onDeselection: ((Int) -> Void)
    
    internal init(_ onSelection: @escaping ((Int) -> Void), _ onDeselection: @escaping ((Int) -> Void)) {
        self.onSelection = onSelection
        self.onDeselection = onDeselection
    }

    private var cellControllers = [SelectableCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func reloadData(with newCellControllers: [SelectableCellController]) {
        cellControllers = newCellControllers
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
        
    func deselect(at index: Int) {
        tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
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
        let isSelected = controller.isSelected?() ?? false
        
        let cell = UITableViewCell()
        if isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.isSelected = true
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
