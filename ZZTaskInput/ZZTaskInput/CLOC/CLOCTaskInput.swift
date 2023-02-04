//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class CLOCTaskInput<T: ZZTextParser, L: ZZItemLoader>: ZZTaskInput where L.Item == String {
    public typealias ItemType = CLOCItemsContainer
    public typealias Section = Int
    
    private let textParser: T
    private let itemLoader: L
    private var loadedItems: [Section: ItemType] = [:]
    
    private(set) public var text: String?
    
    public var onSent: ((ZZTaskInput.Data) -> Void)?
    
    public init(textParser: T, itemLoader: L) {
        self.textParser = textParser
        self.itemLoader = itemLoader
    }

    public func set(text: String?) {
        self.text = text
    }
    
    public func send() {
        guard let text = text, !text.isEmpty else { return }
        
        let parsedComponents = textParser.parse(text: text)
        onSent?(parsedComponents as! (title: String, description: String?))
    }
    
    public func select(section: Section, completion: @escaping FetchItemsCompletion) {
        if let loaded = self.loadedItems[section] {
            completion(.success(loaded))
        } else {
            itemLoader.loadItems(for: section, completion: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let items):
                    let container: CLOCItemsContainer = .init(items: items)
                    completion(.success(container))
                    self.loadedItems[section] = container
                }
            })
        }
    }
}
