//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import UIKit
import ZZTaskInput
import ZZTaskInputiOS

class ZZTaskInputViewTests: XCTestCase {
    
    func test_loadItemsActions_requestSelectFromInputController() {
        let (sut, inputController) = makeSUT()
        XCTAssertEqual(inputController.loadCallCount, 0)
        
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: makeItems())
        XCTAssertEqual(inputController.loadCallCount, 1)
    }

    func test_didMoveToWindow_makesTextFieldFirstResponder() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.isTextFieldFirstResponder)
        
        // Adding the view to window will trigger `didMoveToWindow`
        addToWindow(sut)

        XCTAssertTrue(sut.isTextFieldFirstResponder)
    }
    
    func test_selectedSectionText_isVisibleWhenItemsIsLoaded() {
        let (sut, inputController) = makeSUT()
        XCTAssertTrue(sut.isSectionTextHidden)
 
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: makeItems())
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: 1)
        XCTAssertTrue(sut.isSectionTextHidden)

        inputController.loader.completeRetrieval(with: .none, at: 1)
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: 2)
        XCTAssertTrue(sut.isSectionTextHidden)

        inputController.loader.completeRetrieval(with: makeError(), at: 2)
        XCTAssertFalse(sut.isSectionTextHidden)
    }
    
    func test_loadItemsInSectionCompletion_rendersSuccessfullyLoadedItems() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items)
        
        // when
        sut.simulateSelection(section: 1)
        inputController.loader.completeRetrieval(with: .none, at: 1)

        // then
        assertThat(sut, isRendering: [])
    }
    
    func test_loadItemsInSectionCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: makeError())
        
        // then
        assertThat(sut, isRendering: items)
    }
    
    func test_loadItemsInSectionCompletion_rendersPreselectedItems() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()
        inputController.preselectedItems = [items[1]]
        
        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items, selectedItems: inputController.preselectedItems)
    }
    
    func test_selectingRenderedItemOnSingleSelectionType_removesSelectionIndicatorFromPreviouslySelectedItem() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)

        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 0)

        // when
        sut.simulateItemSelection(at: 1)
        
        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 1)
        assertThat(sut, isNotRenderingSelectedIndicatorElementsAt: 0)
    }
    
    func test_selectingRenderedItemOnSingleSelectionType_doesNotRemoveSelectionIndicatorFromSameSelectedItem() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)

        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 0)

        // when
        sut.simulateItemSelection(at: 0)

        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 0)
    }
    
    func test_deselectingRenderedItemOnSingleSelectionType_doesNotRemoveSelectionIndicator() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)

        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 0)
        
        // when
        sut.simulateItemDeselection(at: 0)

        // then
        assertThat(sut, isRenderingSelectedIndicatorElementsAt: 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ZZTaskInputView, inputController: TaskInputSpy) {
        let inputController = TaskInputSpy()
        let sut = ZZTaskInputView(inputController: inputController)
        
        trackForMemoryLeaks(inputController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, inputController)
    }
    
    private func makeItems() -> [DefaultTaskInput.SelectableItem] {
        return ["a", "b", "c"]
    }
    
    private func makeError() -> NSError {
        return NSError(domain: "error", code: -1)
    }
    
    private func addToWindow(_ sut: ZZTaskInputView) {
        let window = UIWindow()
        window.addSubview(sut)
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isRendering items: [DefaultTaskInput.SelectableItem], selectedItems: [DefaultTaskInput.SelectableItem]? = nil, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedItems, items.count, file: file, line: line)
        
        for (index, item) in items.enumerated() {
            let view = sut.itemView(at: index)
            XCTAssertNotNil(view, file: file, line: line)
            XCTAssertEqual(view?.textLabel?.text, item, file: file, line: line)
            let isPreselected = selectedItems?.contains(item) ?? false
            XCTAssertEqual(isPreselected, view!.isSelectedAndShowingIndicator)
        }
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isRenderingSelectedIndicatorElementsAt index: Int) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0)
        XCTAssertTrue(view0!.isSelectedAndShowingIndicator)
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isNotRenderingSelectedIndicatorElementsAt index: Int) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0)
        XCTAssertFalse(view0!.isSelectedAndShowingIndicator)
    }

    
    class TaskInputSpy: DefaultTaskInput {
        let textParser = MockTextParser()
        let loader = ItemLoaderSpy()
        
        var preselectedItems: [DefaultTaskInput.Data.Item]?
        var loadCallCount: Int { loader.receivedMessages.count }
        
        override func select(section: CLOCSelectableProperty, withPreselectedItems: [DefaultTaskInput.Data.Item]?, completion: @escaping DefaultTaskInput.FetchItemsCompletion) {
            loader.loadItems(for: section) { [weak self] result in
                do {
                    let items = try result.get()
                    let container = CLOCItemsContainer(items: items, preSelectedItems: self?.preselectedItems, selectionType: section.selectionType)
                    completion(.success(container))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

extension ZZTaskInputView {
    func simulateSelection(section: Int) {
        segmentedControl.simulateSelectingItem(at: section)
    }
    
    func simulateItemSelection(at index: Int) {
        let indexPath = IndexPath(row: index, section: section)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func simulateItemDeselection(at index: Int) {
        let indexPath = IndexPath(row: index, section: section)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func itemView(at index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        return ds?.tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
        
    var isTextFieldFirstResponder: Bool {
        textField.isFirstResponder
    }
    
    var isSectionTextHidden: Bool {
        selectedSectionLabel.isHidden
    }
    
    var numberOfRenderedItems: Int {
        tableView.numberOfRows(inSection: section)
    }
    
    private var section: Int { 0 }
}

extension UISegmentedControl {
    func simulateSelectingItem(at index: Int) {
        selectedSegmentIndex = index

        self.allTargets.forEach({ target in
            self.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({ selector in
                (target as NSObject).perform(Selector(selector))
            })
        })
    }
}

extension UITableViewCell {
    var isSelectedAndShowingIndicator: Bool {
        return isSelected && accessoryType == .checkmark
    }
}
