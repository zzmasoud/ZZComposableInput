//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput

class ItemLoaderSpy: ZZItemLoader {
    typealias Item = String

    private(set) var receivedMessages = [Int]()
    private(set) var completions = [FetchItemsCompletion]()

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
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