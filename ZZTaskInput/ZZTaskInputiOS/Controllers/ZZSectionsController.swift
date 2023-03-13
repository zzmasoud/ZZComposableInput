//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public protocol SectionedViewProtocol {
    var view: UIControl { get }
    var selectedSectionIndex: Int { set get }
    var numberOfSections: Int { get }
    func removeAllSections()
    func insertSection(withTitle: String, at: Int)
}

protocol ZZSectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

final class ZZSectionsController: NSObject, SectionsView {
    @IBOutlet private(set) var sectionedViewContainer: UIView?
    @IBOutlet private(set) var label: UILabel?
    
    var sectionedView: SectionedViewProtocol?
    var delegate: ZZSectionsControllerDelegate?
    var loadSection: ((Int) -> Void)?

    func viewDidLoad() {
        label?.isHidden = true
        guard let containerView = sectionedViewContainer else {
            fatalError("sectionedViewContainer property is nil, should be connected in the interface builder.")
        }
        guard let sectionedView = sectionedView else {
            fatalError("sectionedView property should be assigned before viewDidLoad().")
        }
        add(sectionedView: sectionedView.view, to: containerView)
        sectionedView.view.addTarget(self, action: #selector(selectSection), for: .valueChanged)
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

    #warning("here it's sending the selection massege to 2 object. first, a closure to load and couple a table view and second to inform the delegate and change a label's text. is it correct? or it should be one shared presenter to handle both?")
    @objc private func selectSection() {
        guard let index = sectionedView?.selectedSectionIndex else { return }
        loadSection?(index)
        delegate?.didSelectSection(at: index)
    }
    
    func display(_ viewModel: SectionsViewModel) {
        sectionedView?.removeAllSections()
        for (index, title) in (viewModel.titles).enumerated() {
            sectionedView?.insertSection(withTitle: title, at: index)
        }
        sectionedView?.selectedSectionIndex = viewModel.selectedIndex
    }

    func display(_ viewModel: SectionViewModel) {
        label?.isHidden = false
        label?.text = viewModel.title
    }
}
