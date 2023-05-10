//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public final class ZZComposableInputViewController: UIViewController, ZZComposableInput {
    public var resourceListController: ResourceListControllerProtocol! {
        return _resourceListController
    }
    
    public var sectionsController: SectionsControllerProtocol! {
        return _sectionsController
    }
    
    @IBOutlet public var _sectionsController: SectionsController!
    @IBOutlet public var _resourceListController: ResourceListController!
    
    public var sectionedView: SectionedViewProtocol { sectionsController.sectionedView! }
    public var resourceListView: ResourceListViewProtocol { resourceListController.resourceListView! }
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
