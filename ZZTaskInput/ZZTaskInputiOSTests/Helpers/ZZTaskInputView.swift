//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInputiOS
import UIKit

extension ZZTaskInputView {
    func simulateSelection(section: Int = 0) {
        segmentedControl.simulateSelectingItem(at: section)
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
    
    func itemView(at index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        return ds?.tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
        
    var isTextFieldFirstResponder: Bool {
        textField.isFirstResponder
    }
    
    var isSectionTextHidden: Bool {
        selectedSectionLabel?.isHidden ?? true
    }
    
    var sectionText: String? {
        selectedSectionLabel?.text
    }
    
    var numberOfRenderedItems: Int {
        tableView.numberOfRows(inSection: section)
    }
    
    var section: Int { 0 }
    
    var numberOfRenderedSections: Int {
        segmentedControl.numberOfSegments
    }
    
    var selectedSectionIndex: Int {
        segmentedControl.selectedSegmentIndex
    }
}

extension UITableViewCell {
    var isSelectedAndShowingIndicator: Bool {
        return isSelected && accessoryType == .checkmark
    }
}
