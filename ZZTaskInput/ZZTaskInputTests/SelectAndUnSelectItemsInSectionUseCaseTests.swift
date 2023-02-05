//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class SelectAndUnSelectItemsInSectionUseCaseTests: XCTestCase {
    
    func test_send_deliversNilSelectedItems() {
        let (sut, _) = makeSUT()
        fillText(for: sut)
        
        let exp = expectation(description: "waiting for completion")
        sut.onSent = { model in
            XCTAssertTrue(model.selectedItems.isEmpty)
            exp.fulfill()
        }
        
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_send_deliversSelectedItems() {
        let (sut, loader) = makeSUT()
        fillText(for: sut)
        
        sut.select(section: getSection()) { result in
            let container = try? result.get()
            container?.select(at: 0)
        }
        
        sut.select(section: getSection2()) { result in
            let container = try? result.get()
            container?.select(at: 1)
            container?.select(at: 2)
        }
        
        sut.select(section: getSection3(), withPreselectedItems: [loader.items[1]], completion: { _ in })

        let exp = expectation(description: "waiting for completion")
        sut.onSent = { [weak self] model in
            guard let self = self else { return }
            guard !model.selectedItems.isEmpty else {
                return XCTFail("expected to get selected items")
            }
            let selectedItems = model.selectedItems
            
            // the reason for testing both first and last, is that I don't know how to explict the return type to single or multiple (all of them return array but of course some of them is just single selection).
            // Maybe I should use an enum. but I'm still looking for a better way.
            
            XCTAssertEqual(selectedItems[self.getSection()]?.first, loader.items[0])
            XCTAssertEqual(selectedItems[self.getSection()]?.last, loader.items[0])

            XCTAssertEqual(selectedItems[self.getSection2()]?.first, loader.items[2])
            XCTAssertEqual(selectedItems[self.getSection2()]?.last, loader.items[2])
            
            XCTAssertEqual(selectedItems[self.getSection3()]?.first, loader.items[1])
            XCTAssertEqual(selectedItems[self.getSection3()]?.last, loader.items[1])

            exp.fulfill()
        }
        
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
    
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
        typealias Section = CLOCSelectableProperty
        typealias Item = String
        
        let items: [Item]
        
        init(items: [Item]) {
            self.items = items
        }
        
        func loadItems(for section: Section, completion: @escaping FetchItemsCompletion) {
            completion(.success(items))
        }
    }
    
    private func makeItems() -> [String] {
        return ["a", "b", "c"]
    }
    
    private func getSection() -> CLOCSelectableProperty {
        return .date
    }
    
    private func getSection2() -> CLOCSelectableProperty {
        return .time
    }
    
    private func getSection3() -> CLOCSelectableProperty {
        return .project
    }
    
    private func fillText(for sut: CLOCTaskInput<MockTextParser, StubItemLoader>) {
        sut.set(text: "Hello\nWorld")
    }
}
