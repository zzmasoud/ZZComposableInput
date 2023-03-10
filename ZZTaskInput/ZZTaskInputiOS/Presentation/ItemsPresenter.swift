//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

final class ItemsPresenter {
    private let loadingView: ItemsLoadingView
    private let listView: ItemsListView

    init(loadingView: ItemsLoadingView, listView: ItemsListView) {
        self.loadingView = loadingView
        self.listView = listView
    }
    
    func didStartLoadingItems() {
        loadingView.display(ItemsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingItems(with items: [NEED_TO_BE_GENERIC], at index: Int) {
        listView.display(ItemsListViewModel(index: index, items: items))
        loadingView.display(ItemsLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingItems(with error: Error) {
        loadingView.display(ItemsLoadingViewModel(isLoading: false))
    }
    
    static var sections: [String] {  ["date", "time", "project", "weekdaysRepeat"] }
}
