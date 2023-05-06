//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class LoadResourcePresenter {
    private let loadingView: ResourceLoadingView
    private let listView: ResourceListView
    
    public init(loadingView: ResourceLoadingView, listView: ResourceListView) {
        self.loadingView = loadingView
        self.listView = listView
    }
    
    public func didStartLoading() {
        loadingView.display(ResourceLoadingViewModel(
            isLoading: true
        ))
    }
    
    public func didFinishLoading(with items: [AnyItem], at index: Int) {
        loadingView.display(ResourceLoadingViewModel(
            isLoading: false
        ))
        listView.display(ResourceListViewModel(
            index: index,
            items: items
        ))
    }
    
    public func didFinishLoading(with error: Error, at index: Int) {
        loadingView.display(ResourceLoadingViewModel(
            isLoading: false
        ))
        listView.display(ResourceListViewModel(
            index: index,
            items: []
        ))
    }
}
