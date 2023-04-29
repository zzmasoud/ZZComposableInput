//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput
import ZZTaskInputiOS

class MockItemsLoader: ItemsLoader {
    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        guard let category = Category(rawValue: section) else { fatalError("Failed to init Category enum case.") }
        switch category {
        case .fruits:
            completion(.success([
                .init(id: UUID(), title: "Orange"),
                .init(id: UUID(), title: "Apple"),
                .init(id: UUID(), title: "Watermelon"),
                .init(id: UUID(), title: "Banana"),
                preselectedItem,
                .init(id: UUID(), title: "Carrot"),
            ]))
        case .animals:
            completion(.success([
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

            ]))

        case .symbols:
            completion(.success([
                MockItem.init(id: UUID(), title: "Up"),
                .init(id: UUID(), title: "Down"),
                .init(id: UUID(), title: "Left"),
                .init(id: UUID(), title: "Right"),
            ]))
            
        default:
            completion(.failure(NSError(domain: "error", code: -1)))
        }
    }
}

let preselectedItem = MockItem(id: UUID(), title: "Avocado")
