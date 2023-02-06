//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public enum CLOCSelectableProperty: Int {
    case date = 0, time, project, repeatWeekDays
    
    public var selectionType: CLOCItemSelectionType {
        switch self {
        case .date, .time, .project:
            return CLOCItemSelectionType.single
        case .repeatWeekDays:
            return CLOCItemSelectionType.multiple(max: 7)
        }
    }
}

open class DefaultTaskInput: ZZTaskInput {
    public typealias Data = CLOCTaskModel
    public typealias SelectableItem = Data.Item
    public typealias ItemType = CLOCItemsContainer
    public typealias Section = CLOCSelectableProperty

    open var onSent: SendCompletion?
    
    public init() {}
    
    open func send() {
        fatalError("should be implemented in subclasses")
    }
    open func select(section: CLOCSelectableProperty, withPreselectedItems: [Data.Item]?, completion: @escaping FetchItemsCompletion) {
        fatalError("should be implemented in subclasses")
    }
}

public final class CLOCTaskInput<T: ZZTextParser, L: ZZItemLoader>: DefaultTaskInput where L.Item == CLOCTaskModel.Item, L.Section == CLOCSelectableProperty, T.Parsed == (title: String, description: String?) {
    public typealias LoadedContainers = [Section: ItemType]

    private let textParser: T
    private let itemLoader: L
    private var loadedContainers: LoadedContainers = [:]
    private var text: String?

    public init(textParser: T, itemLoader: L) {
        self.textParser = textParser
        self.itemLoader = itemLoader
    }

    public func set(text: String?) {
        self.text = text
    }
    
    public override func send() {
        guard let text = text, !text.isEmpty else { return }
        
        let parsedComponents = textParser.parse(text: text)
    
        let taskModel = CLOCTaskModel(
            title: parsedComponents.title,
            description: parsedComponents.description,
            selectedItems: map(loadedContainers)
        )
        onSent?(taskModel)
    }
    
    private func map(_ containers: LoadedContainers) -> CLOCTaskModel.SelectedItems {
        var selectedItems: CLOCTaskModel.SelectedItems = [:]
        
        for (section, container) in containers {
            if let items = container.selectedItems?.compactMap({ $0 }) {
                selectedItems[section] = items
            }
        }
        return selectedItems
    }
    
    public override func select(section: Section, withPreselectedItems preselectedItems: [L.Item]? = nil, completion: @escaping FetchItemsCompletion) {
        if let loaded = self.loadedContainers[section] {
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
                    self.loadedContainers[section] = container
                }
            })
        }
    }
}
