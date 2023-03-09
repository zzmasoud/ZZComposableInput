//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSectionsController: NSObject, ItemsLoadingView {
    private(set) lazy var view: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: sections)
        segmentedControl.addTarget(self, action: #selector(selectSection), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = -1
        return segmentedControl
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private var sections: [String]
    private let loadSection: (Int) -> Void
    
    init(sections: [String], loadSection: @escaping (Int) -> Void) {
        self.sections = sections
        self.loadSection = loadSection
    }

    @objc private func selectSection() {
        loadSection(view.selectedSegmentIndex)
    }
    
    func display(_ viewModel: ItemsLoadingViewModel) {
        self.label.isHidden = viewModel.isLoading
    }
}
