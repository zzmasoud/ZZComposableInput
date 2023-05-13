//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

class MockSectionsController: NSObject, SectionsControllerProtocol {
    
    var sectionedView: (any SectionedViewProtocol)?
    var delegate: SectionsControllerDelegate?

    init(sectionedView: any SectionedViewProtocol) {
        self.sectionedView = sectionedView
    }

    func viewDidLoad() {
        sectionedView?.onSectionChange = { [weak self] in
            self?.delegate?.didSelectSection(at: self!.sectionedView!.selectedSectionIndex)
        }
        
        delegate?.didRequestSections()
    }
    
    func display(_ viewModel: SectionsViewModel) {
        sectionedView?.reload(withTitles: viewModel.titles)
        sectionedView?.selectedSectionIndex = viewModel.selectedIndex
    }
    
    func display(_ viewModel: SectionViewModel) {}
}
