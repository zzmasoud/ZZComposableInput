//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

protocol ZZItemLoader {
    associatedtype SelectableItem
    typealias FetchItemsResut = Result<[SelectableItem], Error>
    typealias FetchItemsCompletion = (FetchItemsResut) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion)
}

class LoadSelectableItemsUseCasTests: XCTestCase {
    
    func test_init_doesNotMessageLoaderUponCreation() {
        let (_, loader) = makeSUT()
                
        XCTAssertTrue(loader.receivedMessages.isEmpty)
    }
    
    func test_select_requestsItemsRetrieval() {
        let (sut, loader) = makeSUT()
        let section = 0

        sut.select(section: section, completion: { _ in })
        
        XCTAssertEqual(loader.receivedMessages, [section])
    }
    
    func test_select_failsOnRetrievalError() {
        let (sut, loader) = makeSUT()
        let section = 0
        let retrievalError = NSError(domain: "error", code: -1)

        let exp = expectation(description: "waiting for completion...")
        sut.select(section: section, completion: { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error as NSError, retrievalError)
            } else {
                XCTFail("expected to get failure, but got success")
            }
            exp.fulfill()
        })
        
        loader.completeRetrieval(with: retrievalError)
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, loader: ItemLoaderSpy) {
        let textParser = MockTextParser()
        let itemLoader = ItemLoaderSpy()
        let sut = CLOCTaskInput(textParser: textParser, itemLoader: itemLoader)
        return (sut, itemLoader)
    }
}

class ItemLoaderSpy: ZZItemLoader {
    typealias SelectableItem = String

    private(set) var receivedMessages = [Int]()
    private(set) var completions = [FetchItemsCompletion]()

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        receivedMessages.append(section)
        completions.append(completion)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        completions[index](.failure(error))
    }
}
