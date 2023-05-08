//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZComposableInput

protocol SectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

final class SectionsController {
    var delegate: SectionsControllerDelegate?
    
    func viewDidLoad() {
        guard let delegate = delegate else { fatalError("The delegate should be assigned before viewDidLoad()") }
        
        delegate.didRequestSections()
    }
    
    func select(section: Int) {
        delegate?.didSelectSection(at: section)
    }
}
