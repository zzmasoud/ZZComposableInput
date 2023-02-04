//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class CLOCItemsContainerTests: XCTestCase {
    
    func test_init_selectedItemsIsEmpty() {
        let items = ["a"]
        let sut = CLOCItemsContainer(items: items)
        
        XCTAssertNil(sut.selectedItems)
    }
    
    func test_initWithPreSelectedIndexes_selectedItemsIsAssigned() {
        let items = ["a", "b", "c"]
        let preSelectedIndex = 1
        
        let sut = CLOCItemsContainer(items: items, preSelectedIndexes: [preSelectedIndex])
        
        XCTAssertEqual(sut.selectedItems, [items[preSelectedIndex]])
    }
    
    func test_selectAt_setsSelectedItemIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT(selectionType: .single)

        sut.select(at: selectionIndex)

        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])
    }
    
    func test_selectAt_setsSelectedItemOnMultipleCallsIfSingleSelection() {
        var selectionIndex = 0
        let (sut, items) = makeSUT(selectionType: .single)

        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

        selectionIndex = 1
        
        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

    }
    
    func test_unselectAt_doesNothingIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT(selectionType: .single)
        
        sut.select(at: selectionIndex)
        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])

        sut.unselect(at: selectionIndex)

        XCTAssertEqual(sut.selectedItems, [items[selectionIndex]])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(selectionType: CLOCItemSelectionType) -> (sut: CLOCItemsContainer, items: [String]) {
        let items = ["a", "b", "c"]
        let sut = CLOCItemsContainer(items: items, preSelectedIndexes: nil, selectionType: selectionType)
        
        return (sut, items)
    }
}


