//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

protocol ZZItemLoader {
    associatedtype Item
    typealias FetchItemsResut = Result<[Item]?, Error>
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

        expect(sut, toCompleteWith: .failure(retrievalError), onSelectingSection: section) {
            loader.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_select_deliversNoneOnNilRetrieval() {
        let (sut, loader) = makeSUT()
        let section = 0

        expect(sut, toCompleteWith: .success(.init(items: .none)), onSelectingSection: section) {
            loader.completeRetrieval(with: .none)
        }
    }
    
    func test_select_deliversSelectableItemsOnNonEmptyRetrieval() {
        let (sut, loader) = makeSUT()
        let section = 0
        let rawItems = ["a", "b", "c"]

        expect(sut, toCompleteWith: .success(.init(items: rawItems)), onSelectingSection: section) {
            loader.completeRetrieval(with: rawItems)
        }
    }
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, loader: ItemLoaderSpy) {
        let textParser = MockTextParser()
        let itemLoader = ItemLoaderSpy()
        let sut = CLOCTaskInput(textParser: textParser, itemLoader: itemLoader)
        return (sut, itemLoader)
    }
    
    private func expect(_ sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, toCompleteWith expectedResult: CLOCTaskInput<MockTextParser, ItemLoaderSpy>.FetchItemsResult, onSelectingSection section: Int, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting for completion...")
        
        sut.select(section: section, completion: { result in
            switch (expectedResult, result) {
            case let (.failure(expectedError), .failure(error)):
                XCTAssertEqual(expectedError as NSError, error as NSError, file: file, line: line)
                
            case let (.success(expectedContainer), .success(container)):
                XCTAssertEqual(expectedContainer.items, container.items)
                
            default:
                XCTFail("expected to get \(expectedResult) but got \(result)", file: file, line: line)
            }
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}

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
