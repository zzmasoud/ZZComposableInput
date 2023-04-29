//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

final class CustomSegmentedControl: NSObject, SectionedViewProtocol {
    var onSectionChange: (() -> Void)?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return view
    }()
    
    var selectedSectionIndex: Int {
        get { segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    
    var numberOfSections: Int { segmentedControl.numberOfSegments }
    
    func removeAllSections() {
        segmentedControl.removeAllSegments()
    }
    
    func insertSection(withTitle: String, at: Int) {
        segmentedControl.insertSegment(withTitle: withTitle, at: at, animated: false)
    }
    
    var view: UIView { segmentedControl }
    
    @objc private func valueChanged() {
        onSectionChange?()
    }
}
