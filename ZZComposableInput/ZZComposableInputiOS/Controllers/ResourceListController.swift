//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public final class ResourceController<ResourceListView: ResourceListViewProtocol>: NSObject, ResourceListControllerProtocol where ResourceListView.CellController == UIKitSelectableCellController   {
    public func set(cellControllers: [UIKitSelectableCellController]) {
        resourceListView?.reloadData(with: cellControllers)
    }
    
    @IBOutlet public var listViewContainer: UIView?
    
    public var delegate: ResourceListControllerDelegate?
    public var resourceListView: ResourceListView?


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
