//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

protocol ZZSectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

final class ZZSectionsController: NSObject, SectionsView, SectionView {
    @IBOutlet private(set) var segmentedControl: UISegmentedControl!
    @IBOutlet private(set) var label: UILabel!
    
    var loadSection: ((Int) -> Void)?
    var delegate: ZZSectionsControllerDelegate?
    
    func setSections() {
        delegate?.didRequestSections()
    }

    #warning("here it's sending the selection massege to 2 object. first, a closure to load and couple a table view and second to inform the delegate and change a label's text. is it correct? or it should be one shared presenter to handle both?")
    @IBAction private func selectSection() {
        let index = segmentedControl.selectedSegmentIndex
        loadSection?(index)
        delegate?.didSelectSection(at: index)
    }
    
    func disply(_ viewModel: SectionsViewModel) {
        segmentedControl.removeAllSegments()
        for (index, title) in (viewModel.titles).enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = viewModel.defaultSelectedIndex
    }
    
    func display(_ viewModel: SectionViewModel) {
        label.isHidden = false
        label.text = viewModel.title
    }
}
