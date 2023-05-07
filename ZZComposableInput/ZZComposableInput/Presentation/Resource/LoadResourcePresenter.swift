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
    
    private func stopLoading() {
        loadingView.display(ResourceLoadingViewModel(
            isLoading: false
        ))
    }
    
    public func didFinishLoading(with items: [any AnyItem], at index: Int) {
        stopLoading()
        listView.display(ResourceListViewModel(
            index: index,
            items: items
        ))
    }
    
    public func didFinishLoading(with error: Error, at index: Int) {
        stopLoading()
        listView.display(ResourceListViewModel(
            index: index,
            items: []
        ))
    }
}
