//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct CLOCItemsContainer: ZZItemsContainer {
    public typealias Item = String
    public var items: [String]?
    
    public init(items: [String]? = nil) {
        self.items = items
    }
}

public final class CLOCTaskInput<T: ZZTextParser, L: ZZItemLoader>: ZZTaskInput where L.Item == String {
    public typealias ItemType = CLOCItemsContainer
    
    private let textParser: T
    private let itemLoader: L
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
    
    public func select(section: Int, completion: @escaping FetchItemsCompletion) {
        itemLoader.loadItems(for: section, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let items):
                completion(.success(.init(items: items)))
            }
        })
    }
}
