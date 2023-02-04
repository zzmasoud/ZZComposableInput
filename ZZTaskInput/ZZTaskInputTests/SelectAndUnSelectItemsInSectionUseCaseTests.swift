//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class SelectAndUnSelectItemsInSectionUseCaseTests: XCTestCase {
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser, StubItemLoader>, loader: StubItemLoader) {
        let textParser = MockTextParser()
        let itemLoader = StubItemLoader(items: makeItems())
        let sut = CLOCTaskInput(textParser: textParser, itemLoader: itemLoader)
        
        trackForMemoryLeaks(textParser, file: file, line: line)
        trackForMemoryLeaks(itemLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, itemLoader)
    }
    
    private class StubItemLoader: ZZItemLoader {
        typealias Item = String
        let items: [Item]
        
        init(items: [Item]) {
            self.items = items
        }
        
        func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
            completion(.success(items))
        }
    }
    
    private func makeItems() -> [String] {
        return ["a", "b", "c"]
    }
}
