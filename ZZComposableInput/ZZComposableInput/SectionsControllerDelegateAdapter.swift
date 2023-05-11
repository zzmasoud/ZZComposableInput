//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class SectionsControllerDelegateAdapter: SectionsControllerDelegate {
    private let sectionsPresenter: SectionsPresenter
    private let sectionLoadCallback: ((Int) -> Void)?
    
    public init(sectionsPresenter: SectionsPresenter, sectionLoadCallback: ((Int) -> Void)? = nil) {
        self.sectionsPresenter = sectionsPresenter
        self.sectionLoadCallback = sectionLoadCallback
    }

    public func didRequestSections() {
        sectionsPresenter.didRequestSections()
    }
    
    public func didSelectSection(at index: Int) {
        sectionsPresenter.didSelectSection(at: index)
        sectionLoadCallback?(index)
    }
}
