//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

final class SectionsPresenter: ZZSectionsControllerDelegate {
    private let sectionsView: SectionsView
        
    init(sectionsView: SectionsView) {
        self.sectionsView = sectionsView
    }
    
    private let titles = ["date", "time", "project", "weekdaysRepeat"]

    func didRequestSections() {
        sectionsView.disply(SectionsViewModel(
            titles: titles,
            defaultSelectedIndex: -1))
    }
    
    func didSelectSection(at index: Int) {
        sectionsView.display(SectionViewModel(title: titles[index]))
    }
}
