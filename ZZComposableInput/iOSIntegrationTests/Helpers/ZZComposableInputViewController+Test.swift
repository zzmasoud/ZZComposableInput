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
    
    func simulateItemSelection(at indexes: Int...) {
        for index in indexes {
            let indexPath = IndexPath(row: index, section: section)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func simulateItemDeselection(at index: Int) {
        let indexPath = IndexPath(row: index, section: section)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
}

extension UITableViewCell {
    var isSelectedAndShowingIndicator: Bool {
        return isSelected
    }
}
