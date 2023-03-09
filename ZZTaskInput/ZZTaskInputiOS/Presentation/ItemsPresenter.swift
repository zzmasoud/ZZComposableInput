//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

protocol ItemsLoadingView {
    func display(isLoading: Bool)
}

protocol ItemsListView {
    func display(index: Int, items: [NEED_TO_BE_GENERIC])
}

final class ItemsPresenter {
    typealias IndexMapper = (Int) -> CLOCSelectableProperty
        
    private let loader: ZZItemsLoader
    let sections: [String]
    private let indexMapper: IndexMapper

    init(loader: ZZItemsLoader, sections: [String], indexMapper: @escaping IndexMapper) {
        self.loader = loader
        self.sections = sections
        self.indexMapper = indexMapper
    }

    var loadingView: ItemsLoadingView?
    var listView: ItemsListView?
    
    func selectSection(index: Int) {
        loadingView?.display(isLoading: true)
        loader.loadItems(for: index, completion: { [weak self] result in
            self?.loadingView?.display(isLoading: false)
            switch result {
            case .success(let items):
                self?.listView?.display(index: index, items: items ?? [])
            case.failure:
                break
            }
        })
    }
}
