//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final public class SectionsController: NSObject, SectionsControllerProtocol {
    @IBOutlet public var sectionedViewContainer: UIView?
    @IBOutlet public var label: UILabel?

    public var delegate: SectionsControllerDelegate?
    public var sectionedView: (any SectionedViewProtocol)? {
        didSet {
            sectionedView?.onSectionChange = { [weak self] in
                guard let self = self, let view = self.sectionedView else { return }
                self.select(section: view.selectedSectionIndex)
            }
        }
    }
    
    func viewDidLoad() {
        guard let delegate = delegate else { fatalError("The delegate should be assigned before viewDidLoad()") }
        delegate.didRequestSections()
        
        guard let containerView = sectionedViewContainer,
              let sectionedView = sectionedView else {
            fatalError("SectionedViewContainer or sectionedView property is nil, should be assigned before viewDidLoad().")
        }
        add(sectionedView: sectionedView.view as! UIView, to: containerView)
    }
    
    private func add(sectionedView: UIView, to containerView: UIView) {
        containerView.addSubviewWithConstraints(sectionedView)
    }
    
    public func select(section: Int) {
        delegate?.didSelectSection(at: section)
    }
    
    private func configureLabel(title: String?) {
        label?.text = title
        label?.isHidden = title == nil
    }
    
    public func display(_ viewModel: SectionsViewModel) {
        sectionedView?.reload(withTitles: viewModel.titles)
        sectionedView?.selectedSectionIndex = viewModel.selectedIndex
        #warning("what if the first state is not -1 index?")
        configureLabel(title: nil)
    }
    
    public func display(_ viewModel: SectionViewModel) {
        configureLabel(title: viewModel.title)
    }
}
