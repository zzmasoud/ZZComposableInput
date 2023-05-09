//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol ZZComposableInput: ZZComposableInputDataSource, ZZComposableInputDelegate {}

public protocol ZZComposableInputDataSource: AnyObject {
    var sectionsController: SectionsController! { get }
    var resourceListController: ResourceListController! { get }
    var sectionedView: SectionedViewProtocol { get }
    var resourceListView: ResourceListViewProtocol { get }
}

public protocol ZZComposableInputDelegate: AnyObject {
    var onSelection: ((Int) -> Void)? { get set }
    var onDeselection: ((Int) -> Void)? { get set }
}

public final class ZZComposableInputViewController: UIViewController, ZZComposableInput {
    @IBOutlet public var sectionsController: SectionsController!
    @IBOutlet public var resourceListController: ResourceListController!
    
    public var sectionedView: SectionedViewProtocol { sectionsController.sectionedView! }
    public var resourceListView: ResourceListViewProtocol { resourceListController.resourceListView! }
    public var selectedSectionLabel: UILabel? { sectionsController?.label }
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    public var onViewDidLoad: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        sectionsController.viewDidLoad()
        resourceListController.viewDidLoad()
        resourceListController.resourceListView?.onSelection = { [weak self] index in
            self?.onSelection?(index)
        }
        resourceListController.resourceListView?.onDeselection = { [weak self] index in
            self?.onDeselection?(index)
        }
        
        onViewDidLoad?()
    }
}

extension ZZComposableInputViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {}
}
