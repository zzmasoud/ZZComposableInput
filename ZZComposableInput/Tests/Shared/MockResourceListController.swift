//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final class MockResourceListController: NSObject, ResourceListControllerProtocol {
    var resourceListView: MockListView?
    var delegate: ResourceListControllerDelegate?

    init(resourceListView: MockListView) {
        self.resourceListView = resourceListView
    }
        
    func set(cellControllers: [SelectableCellController]) {
        resourceListView?.reloadData(with: cellControllers)
    }

    func viewDidLoad() {
        resourceListView?.onSelection = { [weak self] index in
            self?.delegate?.didSelectResource(at: index)
        }
        resourceListView?.onDeselection = { [weak self] index in
            self?.delegate?.didDeselectResource(at: index)
        }
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        resourceListView?.view.backgroundColor = viewModel.isLoading ? .blue : .systemBackground
    }
}
