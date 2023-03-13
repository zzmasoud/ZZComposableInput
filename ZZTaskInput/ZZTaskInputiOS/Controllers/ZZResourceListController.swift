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

public class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = UITableView()
    public var onSelection: ((Int) -> Void)
    public var onDeselection: ((Int) -> Void)
    
    public init(onSelection: @escaping (Int) -> Void, onDeselection: @escaping (Int) -> Void) {
        self.onSelection = onSelection
        self.onDeselection = onDeselection
    }
    
    public var view: UIView { return tableView }
    
    private var cellControllers: [ZZSelectableCellController] = []

    public func reloadData(with cellControllers: [ZZSelectableCellController]) {
        self.cellControllers = cellControllers
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
        tableView.reloadData()
    }
    
    public func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(controller.isSelected(), animated: true)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}

public final class ZZResourceListController: NSObject, ResourceLoadingView {
    @IBOutlet private(set) var listViewContainer: UIView?
    public var resourceListView: ResourceListViewProtocol?
    
    public var cellControllers = [ZZSelectableCellController]() {
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
    
    public func display(_ viewModel: ZZTaskInput.ResourceListViewModel) {
        
    }
    
    public func display(_ viewModel: ZZTaskInput.ResourceLoadingViewModel) {
        
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
