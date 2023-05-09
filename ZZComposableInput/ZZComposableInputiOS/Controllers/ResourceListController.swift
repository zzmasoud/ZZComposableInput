//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol ResourceListViewProtocol {
    var view: UIView { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [SelectableCellController])
    func reload()
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
}

public final class ResourceListController: NSObject, ResourceLoadingView {
    @IBOutlet public var listViewContainer: UIView?
    
    var resourceListView: ResourceListViewProtocol?
    var cellControllers = [SelectableCellController]() {
        didSet {
            resourceListView?.reloadData(with: cellControllers)
        }
    }
    
    func viewDidLoad() {
        guard let containerView = listViewContainer,
              let resourceListView = resourceListView else {
            fatalError("ListViewContainer or resourceListView property is nil, should be assigned before viewDidLoad().")
        }
        add(resourceListView: resourceListView.view, to: containerView)
    }
    
    func add(resourceListView: UIView, to containerView: UIView) {
        containerView.addSubviewWithConstraints(resourceListView)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
            // no loading for now
    }
    
}
