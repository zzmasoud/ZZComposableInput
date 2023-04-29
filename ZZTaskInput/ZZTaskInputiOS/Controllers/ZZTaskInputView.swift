//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZTaskInput

#warning("This way I removed exposing implementation details (no need to be concerete UIViewController anymore, it can be a view too), but it's missing critical calls in viewDidLoad and ViewDidAppear")
public protocol ZZTaskInputView: AnyObject {
    var text: String? { get set }
    var sectionsController: ZZSectionsController! { get }
    var resourceListController: ZZResourceListController! { get }
    var sectionedView: SectionedViewProtocol { get }
    var resourceListView: ResourceListViewProtocol { get }
    
    var onCompletion: (() -> Void)? { get set }
    var onSelection: ((Int) -> Void)? { get set }
    var onDeselection: ((Int) -> Void)? { get set }
}


public final class ZZTaskInputViewController: UIViewController, ZZTaskInputView, ResourceLoadingView {
    @IBOutlet private(set) public var textField: UITextField!
    @IBOutlet private(set) public var sectionsController: ZZSectionsController!
    @IBOutlet private(set) public var resourceListController: ZZResourceListController!
    
    public var sectionedView: SectionedViewProtocol { sectionsController.sectionedView! }
    public var resourceListView: ResourceListViewProtocol { resourceListController.resourceListView! }
    public var selectedSectionLabel: UILabel? { sectionsController?.label }
    public var text: String? {
        get { textField.text }
        set { textField.text = text }
    }
    
    public var onCompletion: (() -> Void)?
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    public var onViewDidLoad: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #warning("how to achive this? where should I set default UI config? setting this to hidden in the storyboard is somehow ugly because it got disappear from the interface builder")
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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {}
}
