//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class DefaultItemsLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageLoaderUponCreation() {
        let (_, loader) = makeSUT()
                
        XCTAssertTrue(loader.receivedMessages.isEmpty)
    }
    
    func test_select_requestsItemsRetrieval() {
        let (sut, loader) = makeSUT()
        let section = getSection()

        sut.loadItems(for: section, completion: { _ in })
        
        XCTAssertEqual(loader.receivedMessages, [section])
    }
    
    func test_select_failsOnRetrievalError() {
        let (sut, loader) = makeSUT()
        let section = getSection()
        let retrievalError = makeError()

        expect(sut, toCompleteWith: .failure(retrievalError), onSelectingSection: section) {
            loader.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_select_deliversNoneOnNilRetrieval() {
        let (sut, loader) = makeSUT()
        let section = getSection()

        expect(sut, toCompleteWith: .success(.none), onSelectingSection: section) {
            loader.completeRetrieval(with: .none)
        }
    }
    
    func test_select_deliversSelectableItemsOnNonEmptyRetrieval() {
        let (sut, loader) = makeSUT()
        let section = getSection()
        let rawItems = makeItems()

        expect(sut, toCompleteWith: .success(rawItems), onSelectingSection: section) {
            loader.completeRetrieval(with: rawItems)
        }
    }

    func test_select_doesNotRequestItemsRetrievalAfterFirstSuccessRetrieval() {
        let (sut, loader) = makeSUT()
        let section = getSection()

        XCTAssertTrue(loader.receivedMessages.isEmpty)

        sut.loadItems(for: section, completion: {_ in })
        loader.completeRetrieval(with: [])
        
        XCTAssertEqual(loader.receivedMessages.count, 1)

        sut.loadItems(for: section, completion: {_ in })
        loader.completeRetrieval(with: .none)

        XCTAssertEqual(loader.receivedMessages.count, 1)
    }
    
    func test_select_requestsItemsRetrievalIfPreviousRetrievalFailed() {
        let (sut, loader) = makeSUT()
        let section = getSection()

        XCTAssertTrue(loader.receivedMessages.isEmpty)

        sut.loadItems(for: section, completion: {_ in })
        loader.completeRetrieval(with: makeError())

        XCTAssertEqual(loader.receivedMessages.count, 1)

        sut.loadItems(for: section, completion: {_ in })
        loader.completeRetrieval(with: makeError(), at: 1)

        XCTAssertEqual(loader.receivedMessages.count, 2)
    }
    
    func test_select_hasNoSideEffectsWhenSelectionChanges() {
        let (sut, loader) = makeSUT()
        let section = getSection()
        let section2 = getSection2()
        let expectedItems = makeItems()
        let expectedItems2 = makeItems()

        XCTAssertTrue(loader.receivedMessages.isEmpty)

        // 0: loading section 1
        sut.loadItems(for: section, completion: {_ in })
        loader.completeRetrieval(with: makeError())

        XCTAssertEqual(loader.receivedMessages.count, 1)

        // 1: loading section 1
        sut.loadItems(for: section) { result in
            let receivedItems = try? result.get()
            XCTAssertEqual(receivedItems, expectedItems)
        }
        
        // 2: loading section 2
        sut.loadItems(for: section2) { result in
            let receivedItems = try? result.get()
            XCTAssertEqual(receivedItems, expectedItems2)
        }
        
        loader.completeRetrieval(with: expectedItems2, at: 2)
        XCTAssertEqual(loader.receivedMessages.count, 3)
        
        loader.completeRetrieval(with: expectedItems, at: 1)
        XCTAssertEqual(loader.receivedMessages.count, 3)
    }
      
    // MARK: - Helpers

    private typealias SUT = DefaultItemsLoader
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SUT, loader: ItemLoaderSpy) {
        let itemLoader = ItemLoaderSpy()
        let sut = SUT(loader: itemLoader)
        
        trackForMemoryLeaks(itemLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, itemLoader)
    }
    
    private func expect(
        _ sut: SUT,
        toCompleteWith expectedResult: SUT.FetchItemsResult,
        onSelectingSection section: Int,
        andPreselectedItems preselectedItems: [ItemLoaderSpy.Item]? = nil,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line) {
        let exp = expectation(description: "waiting for completion...")

            sut.loadItems(for: section) { result in
            switch (expectedResult, result) {
            case let (.failure(expectedError), .failure(error)):
                XCTAssertEqual(expectedError as NSError, error as NSError, file: file, line: line)

            case let (.success(expectedItems), .success(items)):
                XCTAssertEqual(expectedItems, items, file: file, line: line)

            default:
                XCTFail("expected to get \(expectedResult) but got \(result)", file: file, line: line)
            }
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1)
    }
}
