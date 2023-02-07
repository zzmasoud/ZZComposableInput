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
        guard let onLoad = onLoad else { return }
        onLoading?()
        loader.select(section: section, withPreselectedItems: nil, completion: onLoad)
    }
}
