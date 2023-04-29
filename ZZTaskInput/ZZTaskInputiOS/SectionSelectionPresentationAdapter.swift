//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import ZZTaskInput

final class SectionSelectionPresentationAdapter {
    private let loader: ItemsLoader
    public var presenter: LoadResourcePresenter?
    
    public init(loader: ItemsLoader) {
        self.loader = loader
    }
    
    public func selectSection(index: Int) {
        presenter?.didStartLoading()
        loader.loadItems(for: index, completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.didFinishLoading(with: items ?? [], at: index)
            case.failure(let error):
                self?.presenter?.didFinishLoading(with: error, at: index)
            }
        })
    }
}
