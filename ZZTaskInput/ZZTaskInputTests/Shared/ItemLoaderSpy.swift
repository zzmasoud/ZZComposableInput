//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput

class ItemLoaderSpy: ZZItemsLoader {
    typealias Section = Int
    typealias Item = NEED_TO_BE_GENERIC

    private(set) var receivedMessages = [Section]()
    private(set) var completions = [FetchItemsCompletion]()

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
