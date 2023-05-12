//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

class MockSectionsController: NSObject, SectionsControllerProtocol {
    private lazy var view = MockSectionedView()

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
    }
    
    func display(_ viewModel: SectionViewModel) {}
}
