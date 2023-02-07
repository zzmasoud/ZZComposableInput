//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

class TaskInputSpy: DefaultTaskInput {
    let textParser = MockTextParser()
    let loader = ItemLoaderSpy()
    
    var preselectedItems: [DefaultTaskInput.Data.Item]?
    var loadCallCount: Int { loader.receivedMessages.count }
    
    override func select(section: CLOCSelectableProperty, withPreselectedItems: [DefaultTaskInput.Data.Item]?, completion: @escaping DefaultTaskInput.FetchItemsCompletion) {
        loader.loadItems(for: section) { [weak self] result in
            do {
                let items = try result.get()
                let container = CLOCItemsContainer(items: items, preSelectedItems: self?.preselectedItems, selectionType: section.selectionType)
                completion(.success(container))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
