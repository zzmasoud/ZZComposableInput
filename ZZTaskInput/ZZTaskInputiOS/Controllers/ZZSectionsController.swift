//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final class ZZSectionsController: NSObject {
    typealias IndexMapper = (Int) -> CLOCSelectableProperty
    
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
    
    private let loader: DefaultTaskInput
    private let sections: [String]
    private let indexMapper: IndexMapper
    
    init(loader: DefaultTaskInput, sections: [String], indexMapper: @escaping IndexMapper) {
        self.loader = loader
        self.sections = sections
        self.indexMapper = indexMapper
    }
    
    var onLoading: (() -> Void)?
    var onLoad: DefaultTaskInput.FetchItemsCompletion?
    
    @objc private func selectSection() {
        let index = view.selectedSegmentIndex
        let section = indexMapper(index)

        label.isHidden = true
        loader.select(section: section, withPreselectedItems: nil, completion: { [weak self] result in
            self?.label.isHidden = false
            self?.onLoad?(result)
        })
    }
}
