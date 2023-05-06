//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import XCTest
import ZZComposableInput

class DefaultItemsContainerTests: XCTestCase {
    
    func test_init_selectedItemsIsEmpty() {
        let (sut, _) = makeSUT()

        expect(sut, toHaveSelectedItems: .none)
    }
    
    func test_initWithPreSelectedIndexes_selectedItemsIsAssigned() {
        let preSelectedIndex = 1
        let items = makeItems()
        let sut = DefaultItemsContainer(
            items: items,
            preSelectedIndexes: [preSelectedIndex],
            selectionType: .single,
            allowAdding: true)
        
        expect(sut, toHaveSelectedItems: [items[preSelectedIndex]])
    }
    
    func test_initWithPreSelectedItems_selectedItemsIsAssigned() {
        let items = makeItems()
        let preSelectedItems = [items[0], items[1]]
        let sut = DefaultItemsContainer(
            items: makeItems(),
            preSelectedItems: preSelectedItems,
            selectionType: .single,
            allowAdding: true)
        
        expect(sut, toHaveSelectedItems: preSelectedItems)
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
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])

        selectionIndex = 1
        sut.select(at: selectionIndex)
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])
    }
    
    func test_deselectAt_doesNothingIfSingleSelection() {
        let selectionIndex = 0
        let (sut, items) = makeSUT()
        
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])

        sut.deselect(at: selectionIndex)
        expect(sut, toHaveSelectedItems: [items[selectionIndex]])
    }
    
    func test_selectAtAndDeselectAt_onEmptyHasNoSideEffectsIfSingleSelection() {
        let selectionIndex = 0
        let (sut, _) = makeSUT(withNoItems: true)
        
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: nil)
        
        sut.deselect(at: selectionIndex)
        expect(sut, toHaveSelectedItems: nil)
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
        sut.select(at: 1)
        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[0], items[1]])
        
        sut.select(at: 2)
        sut.select(at: 2)
        expect(sut, toHaveSelectedItems: [items[1], items[2]])

        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[1], items[2]])

        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[2], items[0]])
    }
    
    func test_deselectAt_removesSelectedItemIfMultipleSelection() {
        let (sut, items) = makeSUT(selectionType: .multiple(max: 2))
        
        expect(sut, toHaveSelectedItems: .none)

        sut.select(at: 0)
        expect(sut, toHaveSelectedItems: [items[0]])

        sut.select(at: 1)
        expect(sut, toHaveSelectedItems: [items[0], items[1]])

        sut.deselect(at: 0)
        expect(sut, toHaveSelectedItems: [items[1]])

        sut.deselect(at: 0)
        expect(sut, toHaveSelectedItems: [items[1]])

        sut.deselect(at: 1)
        expect(sut, toHaveSelectedItems: .none)
    }

    func test_selectAtAndDeselectAt_onEmptyHasNoSideEffectsIfMultipleSelection() {
        let selectionIndex = 0
        let (sut, _) = makeSUT(selectionType: .multiple(max: 2), withNoItems: true)
        
        sut.select(at: selectionIndex)
        expect(sut, toHaveSelectedItems: nil)
        
        sut.deselect(at: selectionIndex)
        expect(sut, toHaveSelectedItems: nil)
    }
    
    // MARK: - Delegate
    
    func test_selectAndDeselect_hasNoSideEffectsOnDelegation() {
        let (sut, _) = makeSUT()
        let delegate = MockDelegate()
        sut.delegate = delegate
        
        sut.select(at: 0)
        sut.select(at: 1)
        sut.deselect(at: 0)
        sut.deselect(at: 1)
        sut.select(at: 0)
        
        XCTAssertEqual(delegate.deselections, [])
    }
    
    func test_delegate_callsAfterMaximumSelection() {
        let (sut, _) = makeSUT(selectionType: .multiple(max: 2))
        let delegate = MockDelegate()
        sut.delegate = delegate

        XCTAssertEqual(delegate.deselections, [])

        sut.select(at: 0)
        sut.select(at: 1)
        sut.select(at: 2)
        XCTAssertEqual(delegate.deselections, [0])
        
        sut.select(at: 3)
        XCTAssertEqual(delegate.deselections, [0, 1])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(selectionType: ItemsContainerSelectionType = .single, withNoItems: Bool = false) -> (sut: DefaultItemsContainer<MockItem>, items: [MockItem]) {
        let items = withNoItems ? [] : makeItems()
        let sut = DefaultItemsContainer(
            items: items,
            preSelectedIndexes: nil,
            selectionType: selectionType,
            allowAdding: true)
        
        return (sut, items)
    }
    
    private func expect(_ sut: DefaultItemsContainer<MockItem>, toHaveSelectedItems expectedItems: [MockItem]?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(expectedItems, sut.selectedItems, "expected to get \(String(describing: expectedItems)) selected items but got \(String(describing: sut.selectedItems)) selected items.", file: file, line: line)
    }
    
    private class MockDelegate: ItemsContainerDelegate {
        private(set) var deselections: [Int] = []
        
        func didDeselect(at index: Int) {
            deselections.append(index)
        }
    }
}


