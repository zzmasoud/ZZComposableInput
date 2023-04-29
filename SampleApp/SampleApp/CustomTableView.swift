//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

final class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = UITableView()
    public var onSelection: ((Int) -> Void) = { _ in }
    public var onDeselection: ((Int) -> Void) = { _ in }
    
    public var view: UIView { return tableView }
    
    private var cellControllers: [ZZSelectableCellController] = []

    public func reloadData(with cellControllers: [ZZSelectableCellController]) {
        self.cellControllers = cellControllers
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
        tableView.reloadData()
    }
    
    func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        let isSelected = controller.isSelected?() ?? false
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(isSelected, animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func allowAddNew(_ isOn: Bool) {
        // show a button e.g. in header or footer
    }
}
