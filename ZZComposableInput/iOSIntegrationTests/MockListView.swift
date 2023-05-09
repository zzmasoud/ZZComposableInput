//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInputiOS

final class MockListView: NSObject, ResourceListViewProtocol {
    
    var onSelection: ((Int) -> Void)
    var onDeselection: ((Int) -> Void)
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()

    init(onSelection: @escaping (Int) -> Void, onDeselection: @escaping (Int) -> Void) {
        self.onSelection = onSelection
        self.onDeselection = onDeselection
    }
    
    private var cellControllers = [SelectableCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var view: UIView { tableView }
        
    func reloadData(with newCellControllers: [ZZComposableInputiOS.SelectableCellController]) {
        cellControllers = newCellControllers
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
    
    func allowAddNew(_ isOn: Bool) {
        
    }
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
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath) 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}
