//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
@testable import ZZComposableInput

public final class ZZComposableInputViewController<ResourceListController: ResourceListControllerProtocol, ResourceListView: ResourceListViewProtocol>: UIViewController, ZZComposableInput where ResourceListController.ResourceListView.CellController == ResourceListView.CellController, ResourceListView.CellController == UIKitSelectableCellController {
    public var resourceListController: ResourceListController! {
        return _resourceListController as! ResourceListController
    }
    
    public var sectionsController: SectionsControllerProtocol! {
        return _sectionsController
    }
    
    @IBOutlet public var _sectionsController: SectionsController!
    public var _resourceListController: ResourceController<ResourceListView>!
    
    public var sectionedView: any SectionedViewProtocol { sectionsController.sectionedView! }
    public var resourceListView: any ResourceListViewProtocol { resourceListController.resourceListView! }
    public var selectedSectionLabel: UILabel? { _sectionsController?.label }
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    public var onViewDidLoad: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        _sectionsController.viewDidLoad()
        _resourceListController.viewDidLoad()        
        onViewDidLoad?()
    }
}

extension ZZComposableInputViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {}
}
