//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

final class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {

    private lazy var addButton = {
        let btn = UIButton(type: .roundedRect)
        btn.backgroundColor = #colorLiteral(red: 0.7976415753, green: 0.8931569457, blue: 0.9983754754, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.setTitle("Add New Item", for: .normal)
        return btn
    }()
    
    let tableView: UITableView = UITableView()
    
    public var view: UIView { return tableView }
    public var onSelection: ((Int) -> Void) = { _ in }
    public var onDeselection: ((Int) -> Void) = { _ in }
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return addButton
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        let isSelected = controller.isSelected?() ?? false
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        if isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
        addButton.isHidden = !isOn
    }
}
