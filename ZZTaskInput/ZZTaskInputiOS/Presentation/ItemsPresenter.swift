//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput


final class ItemsPresenter {
    typealias IndexMapper = (Int) -> CLOCSelectableProperty
        
    let sections: [String]
    private let indexMapper: IndexMapper

    init(sections: [String], indexMapper: @escaping IndexMapper) {
        self.sections = sections
        self.indexMapper = indexMapper
    }

    var loadingView: ItemsLoadingView?
    var listView: ItemsListView?
    
    func didStartLoadingItems() {
        loadingView?.display(ItemsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingItems(with items: [NEED_TO_BE_GENERIC], at index: Int) {
        listView?.display(ItemsListViewModel(index: index, items: items))
        loadingView?.display(ItemsLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingItems(with error: Error) {
        loadingView?.display(ItemsLoadingViewModel(isLoading: false))
    }
}
