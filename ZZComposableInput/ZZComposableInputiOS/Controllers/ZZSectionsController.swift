//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public protocol SectionedViewProtocol {
    var view: UIView { get }
    var selectedSectionIndex: Int { set get }
    var numberOfSections: Int { get }
    var onSectionChange: (() -> Void)? { set get }
    func reload(withTitles: [String])
}

public protocol ZZSectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

public final class ZZSectionsController: NSObject, SectionsView {
    @IBOutlet private(set) var sectionedViewContainer: UIView?
    @IBOutlet private(set) public var label: UILabel?
    
    public var sectionedView: SectionedViewProtocol?
    public var delegate: ZZSectionsControllerDelegate?
    public var loadSection: ((Int) -> Void)?

    public func viewDidLoad() {
        label?.isHidden = true
        guard let containerView = sectionedViewContainer else {
            fatalError("sectionedViewContainer property is nil, should be connected in the interface builder.")
        }
        guard var sectionedView = sectionedView else {
            fatalError("sectionedView property should be assigned before viewDidLoad().")
        }
        add(sectionedView: sectionedView.view, to: containerView)
        setSections()
        sectionedView.onSectionChange = { [weak self] in
            self?.selectSection()
        }
    }
    
    private func add(sectionedView: UIView, to containerView: UIView) {
        sectionedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sectionedView)
        
        let constraints = [
            sectionedView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 0
            ),
            sectionedView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: 0
            ),
            sectionedView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 0
            ),
            sectionedView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: 0
            )
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    func setSections() {
        delegate?.didRequestSections()
    }

    private func selectSection() {
        guard let index = sectionedView?.selectedSectionIndex else { return }
        loadSection?(index)
        delegate?.didSelectSection(at: index)
    }
    
    public func display(_ viewModel: SectionsViewModel) {
        sectionedView?.reload(withTitles: viewModel.titles)
        sectionedView?.selectedSectionIndex = viewModel.selectedIndex
    }

    public func display(_ viewModel: SectionViewModel) {
        label?.isHidden = false
        label?.text = viewModel.title
    }
}
