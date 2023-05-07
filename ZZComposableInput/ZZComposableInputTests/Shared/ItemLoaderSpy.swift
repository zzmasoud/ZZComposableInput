//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZComposableInput

final class ItemLoaderSpy: ItemsLoader {
    typealias Section = Int
    typealias Item = MockItem

    private(set) var receivedMessages = [Section]()
    private(set) var tasks = [TaskWrapper]()
    
    public var loadCallCount: Int {
        return receivedMessages.count
    }

    func loadItems(for section: Section, completion: @escaping FetchItemsCompletion) -> CancellableFetch {
        receivedMessages.append(section)
        let task = TaskWrapper(task: MockCancellable(cancelCallback: {}), completion: completion)
        tasks.append(task)
        return task
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        let task = tasks[index]
        guard !task.isCancelled else { return }
        
        task.completion(.failure(error))
    }
    
    func completeRetrieval(with items: [Item]?, at index: Int = 0) {
        let task = tasks[index]
        guard !task.isCancelled else { return }
        
        task.completion(.success(items))
    }
    
    class TaskWrapper: CancellableFetch {
        let task: MockCancellable
        let completion: FetchItemsCompletion
        var isCancelled: Bool
        
        init(task: MockCancellable, completion: @escaping FetchItemsCompletion, isCancelled: Bool = false) {
            self.task = task
            self.completion = completion
            self.isCancelled = isCancelled
        }
        
        func cancel() {
            isCancelled = true
            task.cancel()
        }
    }
}

struct MockCancellable: CancellableFetch {
    var cancelCallback: () -> ()
    
    func cancel() {
        cancelCallback()
    }
}
