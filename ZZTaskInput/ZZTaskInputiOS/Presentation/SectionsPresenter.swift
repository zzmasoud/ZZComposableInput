//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

final class SectionsPresenter: ZZSectionsControllerDelegate {
    private let sectionsView: SectionsView
    
    init(sectionsView: SectionsView) {
        self.sectionsView = sectionsView
    }
    
    func didRequestSections() {
        sectionsView.disply(SectionsViewModel(
            titles: ["date", "time", "project", "weekdaysRepeat"],
            defaultSelectedIndex: -1))
    }
}
