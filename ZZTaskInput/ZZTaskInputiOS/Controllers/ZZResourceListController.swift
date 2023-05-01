//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZTaskInput

#warning("#6 - see below warning first")
public protocol ResourceListViewProtocol {
    var view: UIView { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [ZZSelectableCellController])
    func reload()
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
}

public final class ZZResourceListController: NSObject, ResourceLoadingView {
    #warning("#6 - using place holder view, bcz I couldn't use @IBOutlet for a protocol (ResourceListViewProtocol) and also I want a specific view not any kinf of UIView")
    @IBOutlet private(set) var listViewContainer: UIView?
    public var resourceListView: ResourceListViewProtocol?
    
    public var cellControllers = [ZZSelectableCellController]() {
        didSet {
            resourceListView?.reloadData(with: cellControllers)
        }
    }
    
    public func viewDidLoad() {
        guard let containerView = listViewContainer else {
            fatalError("listViewContainer property is nil, should be connected in the interface builder.")
        }
        guard let resourceListView = resourceListView else {
            fatalError("resourceListView property should be assigned before viewDidLoad().")
        }
        add(resourceListView: resourceListView.view, to: containerView)
    }
    
    public func display(_ viewModel: ZZTaskInput.ResourceLoadingViewModel) {
            // no loading for now
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
