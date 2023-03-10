//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput


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
        loadingView?.display(ItemsLoadingViewModel(isLoading: true))
        loader.loadItems(for: index, completion: { [weak self] result in
            self?.loadingView?.display(ItemsLoadingViewModel(isLoading: false))
            switch result {
            case .success(let items):
                self?.listView?.display(ItemsListViewModel(index: index, items: items ?? []))
            case.failure:
                break
            }
        })
    }
}
