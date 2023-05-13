//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInput

final class MockSectionedView: NSObject, SectionedViewProtocol {
    private var segmentedControl: UISegmentedControl
    
    init(view: UISegmentedControl) {
        self.segmentedControl = view
    }
    
    var onSectionChange: (() -> Void)?
    
    var selectedSectionIndex: Int {
        get { segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    
    var numberOfSections: Int { segmentedControl.numberOfSegments }
    
    func reload(withTitles titles: [String]) {
        segmentedControl.removeAllSegments()
        for (index, title) in titles.enumerated() {
            insertSection(withTitle: title, at: index)
        }
        
        segmentedControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    private func insertSection(withTitle: String, at: Int) {
        segmentedControl.insertSegment(withTitle: withTitle, at: at, animated: false)
    }
    
    var view: UIView { segmentedControl }
    
    @objc private func valueChanged() {
        onSectionChange?()
    }
}
