//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

protocol SectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

final class SectionsController: SectionsView {
    @IBOutlet public var sectionedViewContainer: UIView?
    @IBOutlet public var label: UILabel?

    var delegate: SectionsControllerDelegate?
    var sectionedView: SectionedViewProtocol? {
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
            fatalError("sectionedViewContainer or sectionedView property is nil, should be connected in the interface builder.")
        }
        add(sectionedView: sectionedView.view, to: containerView)
    }
    
    private func add(sectionedView: UIView, to containerView: UIView) {
        containerView.addSubviewWithConstraints(sectionedView)
    }
    
    func select(section: Int) {
        delegate?.didSelectSection(at: section)
    }
    
    private func configureLabel(title: String?) {
        label?.text = title
        label?.isHidden = title == nil
    }
    
    func display(_ viewModel: SectionsViewModel) {
        sectionedView?.reload(withTitles: viewModel.titles)
        sectionedView?.selectedSectionIndex = viewModel.selectedIndex
        #warning("what if the first state is not -1 index?")
        configureLabel(title: nil)
    }
    
    func display(_ viewModel: SectionViewModel) {
        configureLabel(title: viewModel.title)
    }
}

final class SectionsControllerDelegateAdapter: SectionsControllerDelegate {
    private let sectionsPresenter: SectionsPresenter
    
    init(sectionsPresenter: SectionsPresenter) {
        self.sectionsPresenter = sectionsPresenter
    }

    func didRequestSections() {
        sectionsPresenter.didRequestSections()
    }
    
    func didSelectSection(at index: Int) {
        sectionsPresenter.didSelectSection(at: index)
    }
}
