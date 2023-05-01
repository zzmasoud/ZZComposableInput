//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput
import ZZTaskInputiOS

class MockItemsLoader: ItemsLoader {
    private var alreadyLoaded = [Int: [MockItem]]()
    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        guard let category = Category(rawValue: section) else { fatalError("Failed to init Category enum case.") }
        switch category {
        case .fruits, .animals, .symbols:
            completion(.success(getItems(forIndex: section)))
            
        default:
            completion(.failure(NSError(domain: "error", code: -1)))
        }
    }
    
    private func getItems(forIndex index: Int) -> [MockItem] {
        if let loaded = alreadyLoaded[index] { return loaded }
        var items = [MockItem]()
        if index == 0 {
            items = [
                .init(id: UUID(), title: "Orange"),
                .init(id: UUID(), title: "Apple"),
                .init(id: UUID(), title: "Watermelon"),
                .init(id: UUID(), title: "Banana"),
                preselectedItem,
                .init(id: UUID(), title: "Carrot"),
            ]
        } else if index == 1 {
            items = [
                MockItem.init(id: UUID(), title: "Fox"),
                .init(id: UUID(), title: "Tiger"),
                .init(id: UUID(), title: "Elephant"),
                .init(id: UUID(), title: "Panda"),
                .init(id: UUID(), title: "Eagle"),
                .init(id: UUID(), title: "Polar bear"),
                .init(id: UUID(), title: "Dolphin"),
                .init(id: UUID(), title: "Chimpanzee"),
                .init(id: UUID(), title: "Lion"),
                .init(id: UUID(), title: "Kangaroo"),
            ]
        } else if index == 2 {
            items = [
                MockItem.init(id: UUID(), title: "Up"),
                .init(id: UUID(), title: "Down"),
                .init(id: UUID(), title: "Left"),
                .init(id: UUID(), title: "Right"),
            ]
        } else { fatalError() }
        
        alreadyLoaded[index] = items
        return items
    }
}

let preselectedItem = MockItem(id: UUID(), title: "Avocado")
