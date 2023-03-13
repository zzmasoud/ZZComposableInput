//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public protocol ResourceListViewProtocol {
    var view: UIView { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [ZZSelectableCellController])
    func allowMultipleSelection(_ isOn: Bool)
}

class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = UITableView()
    var onSelection: ((Int) -> Void)
    var onDeselection: ((Int) -> Void)
    
    init(onSelection: @escaping (Int) -> Void, onDeselection: @escaping (Int) -> Void) {
        self.onSelection = onSelection
        self.onDeselection = onDeselection
    }
    
    var view: UIView { return tableView }
    
    private var cellControllers: [ZZSelectableCellController] = []

    func reloadData(with cellControllers: [ZZSelectableCellController]) {
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
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(controller.isSelected(), animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}

final class ZZResourceListController: NSObject, ResourceLoadingView {
    @IBOutlet private(set) var listViewContainer: UIView?
    var resourceListView: ResourceListViewProtocol?
    
    var cellControllers = [ZZSelectableCellController]() {
        didSet {
            resourceListView?.reloadData(with: cellControllers)
        }
    }
    
    func viewDidLoad() {
        guard let containerView = listViewContainer else {
            fatalError("listViewContainer property is nil, should be connected in the interface builder.")
        }
        guard let resourceListView = resourceListView else {
            fatalError("resourceListView property should be assigned before viewDidLoad().")
        }
        add(resourceListView: resourceListView.view, to: containerView)
    }
    
    func display(_ viewModel: ZZTaskInput.ResourceListViewModel) {
        
    }
    
    func display(_ viewModel: ZZTaskInput.ResourceLoadingViewModel) {
        
    }
    
    private func add(resourceListView: UIView, to containerView: UIView) {
        resourceListView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(resourceListView)
        
        let constraints = [
            resourceListView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 0
            ),
            resourceListView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: 0
            ),
            resourceListView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 0
            ),
            resourceListView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: 0
            )
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
