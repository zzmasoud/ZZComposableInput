//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSectionsController: NSObject, ItemsLoadingView {
    @IBOutlet private(set) var segmentedControl: UISegmentedControl!
    @IBOutlet private(set) var label: UILabel!
    
    var sections: [String]?
    var loadSection: ((Int) -> Void)?
    
    func setSections() {
        for (index, item) in (sections ?? []).enumerated() {
            segmentedControl.insertSegment(withTitle: item, at: index, animated: false)
        }
    }

    @IBAction private func selectSection() {
        loadSection?(segmentedControl.selectedSegmentIndex)
    }
    
    func display(_ viewModel: ItemsLoadingViewModel) {
        self.label.isHidden = viewModel.isLoading
    }
}
