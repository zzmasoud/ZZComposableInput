//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class CLOCItemsLoader<L: ZZItemsLoader>: ZZItemsLoader {
    public typealias Section = L.Section
    public typealias Item = L.Item
    
    private let loader: L
    private var cachedItems = [Section: [Item]?]()
    
    public init(loader: L) {
        self.loader = loader
    }
    
    public func loadItems(for section: L.Section, completion: @escaping FetchItemsCompletion) {
        if let loadedAlready = cachedItems[section] {
            completion(.success(loadedAlready))
        } else {
            loader.loadItems(for: section, completion: { [weak self] result in
                if let items = try? result.get() {
                    self?.cachedItems[section] = items
                }
                completion(result)
            })
        }
    }
}
