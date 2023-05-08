//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol ZZComposableInput: ZZComposableInputDataSource, ZZComposableInputDelegate {}

public protocol ZZComposableInputDataSource: AnyObject {
    var sectionsController: ZZSectionsController! { get }
    var resourceListController: ZZResourceListController! { get }
    var sectionedView: SectionedViewProtocol { get }
    var resourceListView: ResourceListViewProtocol { get }
}

public protocol ZZComposableInputDelegate: AnyObject {
    var onSelection: ((Int) -> Void)? { get set }
    var onDeselection: ((Int) -> Void)? { get set }
}

public final class ZZComposableInputViewController: UIViewController {
    @IBOutlet private(set) public var sectionsController: ZZSectionsController!
    @IBOutlet private(set) public var resourceListController: ZZResourceListController!
    
    public var selectedSectionLabel: UILabel? { sectionsController?.label }
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    public var onViewDidLoad: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #warning("#5 - how to achive this? where should I set default UI config? setting this to hidden in the storyboard is somehow ugly because it got disappear from the interface builder")
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

extension ZZComposableInputViewController: ZZComposableInputDataSource {
    public var sectionedView: SectionedViewProtocol { sectionsController.sectionedView! }
    public var resourceListView: ResourceListViewProtocol { resourceListController.resourceListView! }
}

extension ZZComposableInputViewController: ZZComposableInputDelegate {}

extension ZZComposableInputViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {}
}
