//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class CLOCItemsContainerTests: XCTestCase {
    
    func test_init_selectedItemsIsEmpty() {
        let (sut, _) = makeSUT()

        expect(sut, toHaveSelectedItems: .none)
    }
    
    func test_initWithPreSelectedIndexes_selectedItemsIsAssigned() {
        let preSelectedIndex = 1
        let items = makeItems()
        let sut = CLOCItemsContainer(items: makeItems(), preSelectedIndexes: [preSelectedIndex], selectionType: .single)
        
        expect(sut, toHaveSelectedItems: [items[preSelectedIndex]])
    }
    
    // MARK: - Single Selection Type
    
    func test_selectAt_setsSelectedItemIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT()

        sut.select(at: selectionIndex)

        expect(sut, toHaveSelectedItems: [items[selectionIndex]])
    }
    
    func test_selectAt_setsSelectedItemOnMultipleCallsIfSingleSelection() {
        var selectionIndex = 0
        let (sut, items) = makeSUT()

        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])

        selectionIndex = 1
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])

    }
    
    func test_unselectAt_doesNothingIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT()
        
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])

        sut.unselect(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])
    }
    
    // MARK: - Multiple Selection Type
    
    func test_selectAt_appendsSelectedItemIfMultipleSelection() {
        let (sut, items) = makeSUT(selectionType: .multiple(max: 2))
        
        expect(sut, toHaveSelectedItems: .none)

        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[0]])

        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[0], items[1]])
    }
    
    func test_selectAt_replacesNewSelectedItemToFirstSelectedItemIfMaxMultipleSelectionReached() {
        let (sut, items) = makeSUT(selectionType: .multiple(max: 2))

        sut.select(at: 0)
        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[0], items[1]])
        
        sut.select(at: 2)
        expect(sut, toHaveSelectedItems: [items[1], items[2]])
        
        sut.select(at: 2)
        expect(sut, toHaveSelectedItems: [items[1], items[2]])

        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[1], items[2]])

        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[2], items[0]])
    }
    
    func test_unselectAt_removesSelectedItemIfMultipleSelection() {
        let (sut, items) = makeSUT(selectionType: .multiple(max: 2))
        
        expect(sut, toHaveSelectedItems: .none)

        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[0]])

        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[0], items[1]])

        sut.unselect(at: 0)
        expect(sut, toHaveSelectedItems: [items[1]])

        sut.unselect(at: 0)
        expect(sut, toHaveSelectedItems: [items[1]])

        sut.unselect(at: 1)
        expect(sut, toHaveSelectedItems: .none)
    }

    
    // MARK: - Helpers
    
    private func makeSUT(selectionType: CLOCItemSelectionType = .single) -> (sut: CLOCItemsContainer, items: [String]) {
        let items = ["a", "b", "c"]
        let sut = CLOCItemsContainer(items: items, preSelectedIndexes: nil, selectionType: selectionType)
        
        return (sut, items)
    }
    
    private func makeItems() -> [String] {
        return ["a", "b", "c"]
    }
    
    private func expect(_ sut: CLOCItemsContainer, toHaveSelectedItems expectedItems: [String]?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(expectedItems, sut.selectedItems, "expected to get \(String(describing: expectedItems)) selected items but got \(String(describing: sut.selectedItems)) selected items.", file: file, line: line)
    }
}


