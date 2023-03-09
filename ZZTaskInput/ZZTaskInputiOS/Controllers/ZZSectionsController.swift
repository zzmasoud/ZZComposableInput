//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSectionsController: NSObject, ItemsLoadingView {
    private(set) lazy var view: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: presenter.sections)
        segmentedControl.addTarget(self, action: #selector(selectSection), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = -1
        return segmentedControl
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let presenter: ItemsPresenter
    
    init(presenter: ItemsPresenter) {
        self.presenter = presenter
    }

    @objc private func selectSection() {
        presenter.selectSection(index: view.selectedSegmentIndex)
    }
    
    func display(_ viewModel: ItemsLoadingViewModel) {
        self.label.isHidden = viewModel.isLoading
    }
}
