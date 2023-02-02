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
        let (sut, loader) = makeSUT()
        
        sut.select(section: 0, completion: { _ in })
        
        XCTAssertTrue(loader.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser>, loader: ItemLoaderSpy) {
        let textParser = MockTextParser()
        let itemLoader = ItemLoaderSpy()
        let sut = CLOCTaskInput(textParser: textParser)
        return (sut, itemLoader)
    }
    
    class ItemLoaderSpy: ZZItemLoader {
        typealias SelectableItem = String

        private(set) var receivedMessages = [Int]()
        
        func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
            receivedMessages.append(section)
        }
    }
}
