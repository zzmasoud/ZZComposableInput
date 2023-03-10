//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

protocol ZZSectionsControllerDelegate {
    func didRequestSections()
}

final class ZZSectionsController: NSObject, SectionsView, ItemsLoadingView {
    @IBOutlet private(set) var segmentedControl: UISegmentedControl!
    @IBOutlet private(set) var label: UILabel!
    
    var loadSection: ((Int) -> Void)?
    var delegate: ZZSectionsControllerDelegate?
    
    func setSections() {
        delegate?.didRequestSections()
    }

    @IBAction private func selectSection() {
        loadSection?(segmentedControl.selectedSegmentIndex)
    }
    
    func disply(_ viewModel: SectionsViewModel) {
        for (index, title) in (viewModel.titles).enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = viewModel.defaultSelectedIndex
    }
    
    func display(_ viewModel: ItemsLoadingViewModel) {
        label.isHidden = viewModel.isLoading
    }
}
