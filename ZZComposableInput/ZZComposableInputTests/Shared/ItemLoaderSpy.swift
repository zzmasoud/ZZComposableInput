//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZComposableInput

final class ItemLoaderSpy: ItemsLoader {
    typealias Section = Int
    typealias Item = MockItem

    private(set) var receivedMessages = [Section]()
    private(set) var completions = [FetchItemsCompletion]()
    
    public var loadCallCount: Int {
        return receivedMessages.count
    }

    func loadItems(for section: Section, completion: @escaping FetchItemsCompletion) {
        receivedMessages.append(section)
        completions.append(completion)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeRetrieval(with items: [Item]?, at index: Int = 0) {
        completions[index](.success(items))
    }
}
