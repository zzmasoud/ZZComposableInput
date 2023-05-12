//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final class MockResourceListController: NSObject, ResourceListControllerProtocol {

    private lazy var listView = MockListView({_ in}, {_ in})
    
    var delegate: ResourceListControllerDelegate?
    var resourceListView: MockListView? { listView }
    
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
            // no loading for now
    }
}
