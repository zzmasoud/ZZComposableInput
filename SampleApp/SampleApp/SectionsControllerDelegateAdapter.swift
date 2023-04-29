//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput
import ZZTaskInputiOS

public final class SectionsControllerDelegateAdapter: ZZSectionsControllerDelegate {
    private let sectionsPresenter: SectionsPresenter
    private var resourceViewTogglingPresenter: ResourceViewTogglingPresenter?
    
    public init(sectionsPresenter: SectionsPresenter, resourceViewTogglingPresenter: ResourceViewTogglingPresenter) {
        self.sectionsPresenter = sectionsPresenter
        self.resourceViewTogglingPresenter = resourceViewTogglingPresenter
    }
    
    public func didRequestSections() {
        sectionsPresenter.didRequestSections()
    }
    
    public func didSelectSection(at index: Int) {
        sectionsPresenter.didSelectSection(at: index)
        callTogglingPresenterOnlyOnce()
    }
    
    private func callTogglingPresenterOnlyOnce() {
        resourceViewTogglingPresenter?.selectSection()
        resourceViewTogglingPresenter = nil
    }
}
