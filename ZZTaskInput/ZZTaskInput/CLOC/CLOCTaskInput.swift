//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public enum CLOCSelectableProperty: Hashable {
    case date, time, project, repeatWeekDays
    
    var selectionType: CLOCItemSelectionType {
        switch self {
        case .date, .time, .project:
            return CLOCItemSelectionType.single
        case .repeatWeekDays:
            return CLOCItemSelectionType.multiple(max: 7)
        }
    }
}

public struct CLOCTaskModel {
    public typealias Section = CLOCSelectableProperty
    public typealias Item = String
    
    public var title: String
    public var description: String?
    public var selectedItems: [Section : [Item]]?
    
    public init(title: String, description: String?, selectedItems: [Section: [Item]]? = nil) {
        self.title = title
        self.description = description
        self.selectedItems = selectedItems
    }
}

public final class CLOCTaskInput<T: ZZTextParser, L: ZZItemLoader>: ZZTaskInput where L.Item == CLOCTaskModel.Item, L.Section == CLOCSelectableProperty, T.Parsed == (title: String, description: String?) {
    public typealias Data = CLOCTaskModel
    public typealias SelectableItem = L.Item
    public typealias Section = L.Section
    public typealias ItemType = CLOCItemsContainer

    private let textParser: T
    private let itemLoader: L
    private var loadedItems: [Section: ItemType] = [:]
    private var text: String?
    public var onSent: SendCompletion?

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
        var selectedItems: [Section : [L.Item]]?
        
        for (section, container) in loadedItems {
            if let items = container.selectedItems {
                if (selectedItems?[section] = items) == nil {
                    selectedItems = [section: items]
                }
            }
        }
        
        let taskModel = CLOCTaskModel(title: parsedComponents.title, description: parsedComponents.description, selectedItems: selectedItems)
        onSent?(taskModel)
    }
    
    public func select(section: Section, withPreselectedItems preselectedItems: [L.Item]? = nil, completion: @escaping FetchItemsCompletion) {
        if let loaded = self.loadedItems[section] {
            completion(.success(loaded))
        } else {
            itemLoader.loadItems(for: section, completion: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let items):
                    let container: CLOCItemsContainer = .init(items: items, preSelectedItems: preselectedItems, selectionType: section.selectionType)
                    completion(.success(container))
                    self.loadedItems[section] = container
                }
            })
        }
    }
}
