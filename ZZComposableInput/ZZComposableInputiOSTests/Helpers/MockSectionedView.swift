//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInputiOS

final class MockSectionedView: NSObject, SectionedViewProtocol {
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
    }
    
    func reload(withTitles titles: [String]) {
        segmentedControl.removeAllSegments()
        for (index, title) in titles.enumerated() {
            insertSection(withTitle: title, at: index)
        }
    }
    
    private func insertSection(withTitle: String, at: Int) {
        segmentedControl.insertSegment(withTitle: withTitle, at: at, animated: false)
    }
    
    var view: UIView { segmentedControl }
    
    @objc private func valueChanged() {
        onSectionChange?()
    }
}
