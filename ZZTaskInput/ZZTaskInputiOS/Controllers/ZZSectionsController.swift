//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSectionsController: NSObject {
    private(set) lazy var view: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.sections)
        segmentedControl.selectedSegmentIndex = -1
        return bind(segmentedControl)
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let viewModel: ZZSectionsViewModel
    var onLoading: (() -> Void)?
    
    init(viewModel: ZZSectionsViewModel) {
        self.viewModel = viewModel
    }
    
    private func bind(_ view: UISegmentedControl) -> UISegmentedControl {
        view.addTarget(self, action: #selector(selectSection), for: .valueChanged)
        viewModel.onLoading = { [weak self] isLoading in
            self?.label.isHidden = isLoading
        }
        return view
    }
    
    @objc private func selectSection() {
        viewModel.selectSection(index: view.selectedSegmentIndex)
    }
}
