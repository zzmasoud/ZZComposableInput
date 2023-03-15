//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class SectionsPresenter {
    private let titles: [String]
    private let view: SectionsView
    
    public init(titles: [String], view: SectionsView) {
        self.titles = titles
        self.view = view
    }
    
    public func didRequestSections() {
        view.display(SectionsViewModel(
            titles: titles,
            selectedIndex: -1
        ))
    }
    
    public func didSelectSection(at index: Int) {
        view.display(SectionViewModel(
            title: titles[index]
        ))
    }
}
