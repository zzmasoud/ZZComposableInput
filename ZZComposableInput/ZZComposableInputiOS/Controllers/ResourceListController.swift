//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol ResourceListViewProtocol: AnyObject {
    associatedtype View
    var view: View { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [SelectableCellController])
    func reload()
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
    func deselect(at: Int)
}

public protocol ResourceListControllerDelegate {
    func didSelectResource(at: Int)
    func didDeselectResource(at: Int)
}

public protocol ResourceListControllerProtocol: AnyObject, ResourceLoadingView {
    var delegate: ResourceListControllerDelegate? { get set }
    var resourceListView: (any ResourceListViewProtocol)? { get }
    func set(cellControllers: [SelectableCellController])
}

public final class ResourceListController: NSObject, ResourceListControllerProtocol {
    @IBOutlet public var listViewContainer: UIView?
    
    public var delegate: ResourceListControllerDelegate?
    public var resourceListView: (any ResourceListViewProtocol)?
    
    public func set(cellControllers: [SelectableCellController]) {
        resourceListView?.reloadData(with: cellControllers)
    }

    func viewDidLoad() {
        guard let containerView = listViewContainer,
              let resourceListView = resourceListView else {
            fatalError("ListViewContainer or resourceListView property is nil, should be assigned before viewDidLoad().")
        }
        add(resourceListView: resourceListView.view as! UIView, to: containerView)
        
        resourceListView.onSelection = { [weak self] index in
            self?.delegate?.didSelectResource(at: index)
        }
        resourceListView.onDeselection = { [weak self] index in
            self?.delegate?.didDeselectResource(at: index)
        }
    }
    
    func add(resourceListView: UIView, to containerView: UIView) {
        containerView.addSubviewWithConstraints(resourceListView)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
            // no loading for now
    }
    
}
