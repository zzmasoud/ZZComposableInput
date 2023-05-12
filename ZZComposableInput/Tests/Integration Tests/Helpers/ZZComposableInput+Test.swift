//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
@testable import ZZComposableInput

extension ZZComposableInput {
    var tableView: UITableView { self.resourceListController.resourceListView!.view as! UITableView }
    
    var section: Int { 0 }
    
    var numberOfRenderedItems: Int {
        tableView.numberOfRows(inSection: section)
    }
    
    var isMultiSelection: Bool {
        tableView.allowsMultipleSelection
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

extension ZZComposableInput {
    var numberOfRenderedSections: Int {
        sectionsController.sectionedView!.numberOfSections
    }
    
    var selectedSectionIndex: Int {
        sectionsController.sectionedView!.selectedSectionIndex
    }
    
    func simulateSelection(section: Int) {
        sectionsController.sectionedView!.simulateSelection(section: section)
    }
}

extension UITableViewCell {
    var isSelectedAndShowingIndicator: Bool {
        return isSelected
    }
}
