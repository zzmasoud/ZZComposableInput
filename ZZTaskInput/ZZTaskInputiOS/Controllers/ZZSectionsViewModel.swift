//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

final class ZZSectionsViewModel {
    typealias IndexMapper = (Int) -> CLOCSelectableProperty
    
    private let loader: ZZItemsLoader
    let sections: [String]
    private let indexMapper: IndexMapper

    init(loader: ZZItemsLoader, sections: [String], indexMapper: @escaping IndexMapper) {
        self.loader = loader
        self.sections = sections
        self.indexMapper = indexMapper
    }

    var onLoading: ((Bool) -> Void)?
    var onLoad: ((Int, CLOCItemsLoader.FetchItemsResult) -> Void)?
    
    func selectSection(index: Int) {
        onLoading?(true)
        loader.loadItems(for: index, completion: { [weak self] result in
            self?.onLoading?(false)
            self?.onLoad?(index, result)
        })
    }
}
