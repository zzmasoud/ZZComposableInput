//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInputiOS

extension ZZComposableInputViewController {
    var tableView: UITableView { resourceListView.view as! UITableView }
    
    var section: Int { 0 }

    var numberOfRenderedSections: Int {
        sectionedView.numberOfSections
    }

    var numberOfRenderedItems: Int {
        tableView.numberOfRows(inSection: section)
    }
    
    var isMultiSelection: Bool {
        tableView.allowsMultipleSelection
    }
    var selectedSectionIndex: Int {
        sectionedView.selectedSectionIndex
    }
    
    func simulateSelection(section: Int) {
        sectionedView.simulateSelection(section: section)
    }
    
    func itemView(at index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        return ds?.tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
}

extension UITableViewCell {
    var isSelectedAndShowingIndicator: Bool {
        return isSelected && accessoryType == .checkmark
    }
}
