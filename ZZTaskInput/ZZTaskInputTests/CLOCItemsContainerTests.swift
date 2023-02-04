//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class CLOCItemsContainerTests: XCTestCase {
    
    func test_init_selectedItemsIsEmpty() {
        let (sut, _) = makeSUT()

        XCTAssertNil(sut.selectedItems)
    }
    
    func test_initWithPreSelectedIndexes_selectedItemsIsAssigned() {
        let preSelectedIndex = 1
        let items = makeItems()
        let sut = CLOCItemsContainer(items: makeItems(), preSelectedIndexes: [preSelectedIndex], selectionType: .single)
        
        XCTAssertEqual(sut.selectedItems, [items[preSelectedIndex]])
    }
    
    // MARK: - Single Selection Type
    
    func test_selectAt_setsSelectedItemIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT()

        sut.select(at: selectionIndex)

        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])
    }
    
    func test_selectAt_setsSelectedItemOnMultipleCallsIfSingleSelection() {
        var selectionIndex = 0
        let (sut, items) = makeSUT()

        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

        selectionIndex = 1
        
        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

    }
    
    func test_unselectAt_doesNothingIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT()
        
        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

        sut.unselect(at: selectionIndex)

        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])
    }
    
    // MARK: - Multiple Selection Type
    
    func test_selectAt_appendsSelectedItemIfMultipleSelection() {
        let (sut, items) = makeSUT(selectionType: .multiple(max: 3))
        
        XCTAssertNil(sut.selectedItems)

        sut.select(at: 0)
        XCTAssertEqual(sut.selectedItems, [items[0]])

        sut.select(at: 1)
        XCTAssertEqual(sut.selectedItems, [items[0], items[1]])
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
}


