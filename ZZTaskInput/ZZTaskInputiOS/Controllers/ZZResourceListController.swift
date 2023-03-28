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
