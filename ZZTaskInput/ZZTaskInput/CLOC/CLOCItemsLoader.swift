//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class CLOCItemsLoader: ZZItemsLoader {
    private let loader: ZZItemsLoader
    private var cachedItems = [Int: [NEED_TO_BE_GENERIC]?]()
    
    public init(loader: ZZItemsLoader) {
        self.loader = loader
    }
    
    public func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        if let loadedAlready = cachedItems[section] {
            completion(.success(loadedAlready))
        } else {
            loader.loadItems(for: section, completion: { [weak self] result in
                if let items = try? result.get() {
                    self?.cachedItems[section] = items
                }
                if let loadedAlready = self?.cachedItems[section] {
                    completion(.success(loadedAlready))
                } else {
                    completion(result)
                }
            })
        }
    }
}
