//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import ZZComposableInput

final class LoadResourcePresentationAdapter<Loader: ItemsLoader> {
    private let loader: Loader
    public var presenter: LoadResourcePresenter?
    private var currentTask: CancellableFetch? {
        didSet {
             oldValue?.cancel()
        }
    }
    
    init(loader: Loader) {
        self.loader = loader
    }
    
    func selectSection(index: Int) {
        presenter?.didStartLoading()
        currentTask = loader.loadItems(for: index, completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.didFinishLoading(with: items, at: index)
            case.failure(let error):
                self?.presenter?.didFinishLoading(with: error, at: index)
            }
        })
    }
}
