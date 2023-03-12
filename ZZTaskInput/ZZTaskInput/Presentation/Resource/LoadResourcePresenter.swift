//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

final class LoadResourcePresenter {
    private let loadingView: ResourceLoadingView
    private let listView: ResourceListView

    init(loadingView: ResourceLoadingView, listView: ResourceListView) {
        self.loadingView = loadingView
        self.listView = listView
    }
    
    func didStartLoadingItems() {
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingItems(with items: [NEED_TO_BE_GENERIC], at index: Int) {
        listView.display(ResourceListViewModel(index: index, items: items))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingItems(with error: Error, at index: Int) {
        listView.display(ResourceListViewModel(index: index, items: []))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
