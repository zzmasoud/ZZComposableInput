//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct SectionsViewModel {
    public let titles: [String]
    public let selectedIndex: Int
    
    public init(titles: [String], selectedIndex: Int) {
        self.titles = titles
        self.selectedIndex = selectedIndex
    }
}
