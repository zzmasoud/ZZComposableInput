//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

class MockSectionsController: NSObject, SectionsControllerProtocol {
    private lazy var view = MockSectionedView()
    private lazy var label = UILabel()

    var delegate: SectionsControllerDelegate?
    var sectionedView: (any SectionedViewProtocol)? { view }

    func viewDidLoad() {
        view.onSectionChange = { [weak self] in
            self?.delegate?.didSelectSection(at: self!.sectionedView!.selectedSectionIndex)
        }
        
        delegate?.didRequestSections()
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
    
    private func configureLabel(title: String?) {
        label.text = title
        label.isHidden = title == nil
    }
}
