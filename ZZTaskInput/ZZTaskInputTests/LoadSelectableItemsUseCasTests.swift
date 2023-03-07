//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class LoadSelectableItemsUseCasTests: XCTestCase {
    
//    func test_init_doesNotMessageLoaderUponCreation() {
//        let (_, loader) = makeSUT()
//                
//        XCTAssertTrue(loader.receivedMessages.isEmpty)
//    }
//    
//    func test_select_requestsItemsRetrieval() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//
//        sut.select(section: section, completion: { _ in })
//        
//        XCTAssertEqual(loader.receivedMessages, [section])
//    }
//    
//    func test_select_failsOnRetrievalError() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//        let retrievalError = NSError(domain: "error", code: -1)
//
//        expect(sut, toCompleteWith: .failure(retrievalError), onSelectingSection: section) {
//            loader.completeRetrieval(with: retrievalError)
//        }
//    }
//    
//    func test_select_deliversNoneOnNilRetrieval() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//
//        expect(sut, toCompleteWith: .success(.init(items: .none, preSelectedIndexes: .none)), onSelectingSection: section) {
//            loader.completeRetrieval(with: .none)
//        }
//    }
//    
//    func test_select_deliversSelectableItemsOnNonEmptyRetrieval() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//        let rawItems = ["a", "b", "c"]
//
//        expect(sut, toCompleteWith: .success(.init(items: rawItems, preSelectedIndexes: .none)), onSelectingSection: section) {
//            loader.completeRetrieval(with: rawItems)
//        }
//    }
//    
//    func test_selectWithPreselectedItems_deliversSelectableItemsWithPreselectedOnes() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//        let rawItems = ["a", "b", "c"]
//        let preselectedItems = ["a"]
//        
//        expect(sut, toCompleteWith: .success(.init(items: rawItems, preSelectedItems: preselectedItems)), onSelectingSection: section, andPreselectedItems: preselectedItems) {
//            loader.completeRetrieval(with: rawItems)
//        }
//    }
//    
//    func test_select_doesNotRequestItemsRetrievalAfterFirstSuccessRetrieval() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//
//        XCTAssertTrue(loader.receivedMessages.isEmpty)
//
//        sut.select(section: section, completion: {_ in })
//        loader.completeRetrieval(with: .none)
//        
//        XCTAssertEqual(loader.receivedMessages.count, 1)
//
//        sut.select(section: section, completion: {_ in })
//        loader.completeRetrieval(with: .none)
//
//        XCTAssertEqual(loader.receivedMessages.count, 1)
//    }
//    
//    func test_select_requestsItemsRetrievalIfPreviousRetrievalFailed() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//
//        XCTAssertTrue(loader.receivedMessages.isEmpty)
//
//        sut.select(section: section, completion: {_ in })
//        loader.completeRetrieval(with: NSError())
//
//        XCTAssertEqual(loader.receivedMessages.count, 1)
//
//        sut.select(section: section, completion: {_ in })
//        loader.completeRetrieval(with: NSError(), at: 1)
//
//        XCTAssertEqual(loader.receivedMessages.count, 2)
//    }
//    
//    func test_select_hasNoSideEffectsWhenSelectionChanges() {
//        let (sut, loader) = makeSUT()
//        let section = getSection()
//        let section2 = getSection2()
//        let expectedItems = ["a", "b", "c"]
//        let expectedItems2 = ["aaa", "bbb", "ccc"]
//
//        XCTAssertTrue(loader.receivedMessages.isEmpty)
//
//        sut.select(section: section, completion: {_ in })
//        loader.completeRetrieval(with: NSError())
//
//        XCTAssertEqual(loader.receivedMessages.count, 1)
//
//        sut.select(section: section) { result in
//            let container = try? result.get()
//            XCTAssertEqual(container?.items, expectedItems)
//        }
//        
//        sut.select(section: section2) { result in
//            let container = try? result.get()
//            XCTAssertEqual(container?.items, expectedItems2)
//        }
//        
//        loader.completeRetrieval(with: expectedItems2, at: 2)
//        XCTAssertEqual(loader.receivedMessages.count, 3)
//        
//        loader.completeRetrieval(with: expectedItems, at: 1)
//        XCTAssertEqual(loader.receivedMessages.count, 3)
//    }
//    
//    func test_select_doesNotDeliverResultAfterSUTHasbeenDeallocated() {
//        var (sut, loader): (CLOCTaskInput?, ItemLoaderSpy) = makeSUT()
//        let section = getSection()
//
//        var capturedResult = false
//        sut?.select(section: section, completion: { _ in
//            capturedResult = true
//        })
//        
//        sut = nil
//
//        loader.completeRetrieval(with: .none)
//        
//        XCTAssertFalse(capturedResult)
//    }
//        
//    // MARK: - Helpers
//    
//    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, loader: ItemLoaderSpy) {
//        let textParser = MockTextParser()
//        let itemLoader = ItemLoaderSpy()
//        let sut = CLOCTaskInput(textParser: textParser, itemLoader: itemLoader)
//        
//        trackForMemoryLeaks(textParser, file: file, line: line)
//        trackForMemoryLeaks(itemLoader, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//
//        return (sut, itemLoader)
//    }
//    
//    private func expect(_ sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, toCompleteWith expectedResult: CLOCTaskInput<MockTextParser, ItemLoaderSpy>.FetchItemsResult, onSelectingSection section: CLOCSelectableProperty, andPreselectedItems preselectedItems: [ItemLoaderSpy.Item]? = nil, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
//        let exp = expectation(description: "waiting for completion...")
//        
//        sut.select(section: section, withPreselectedItems: preselectedItems, completion: { result in
//            switch (expectedResult, result) {
//            case let (.failure(expectedError), .failure(error)):
//                XCTAssertEqual(expectedError as NSError, error as NSError, file: file, line: line)
//                
//            case let (.success(expectedContainer), .success(container)):
//                XCTAssertEqual(expectedContainer.items, container.items, file: file, line: line)
//                XCTAssertEqual(expectedContainer.selectedItems, container.selectedItems, file: file, line: line)
//                
//            default:
//                XCTFail("expected to get \(expectedResult) but got \(result)", file: file, line: line)
//            }
//            exp.fulfill()
//        })
//        
//        action()
//        
//        wait(for: [exp], timeout: 1)
//    }
//    
//    private func getSection() -> CLOCSelectableProperty {
//        return .date
//    }
//    
//    private func getSection2() -> CLOCSelectableProperty {
//        return .time
//    }
}
