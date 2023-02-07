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
        
        sut.simulateSelection()
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
 
        sut.simulateSelection()
        inputController.loader.completeRetrieval(with: makeItems())
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: singleSelectionSection1)
        XCTAssertTrue(sut.isSectionTextHidden)

        inputController.loader.completeRetrieval(with: .none, at: 1)
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: singleSelectionSection2)
        XCTAssertTrue(sut.isSectionTextHidden)

        inputController.loader.completeRetrieval(with: makeError(), at: 2)
        XCTAssertFalse(sut.isSectionTextHidden)
    }
    
    func test_loadItemsInSectionCompletion_rendersSuccessfullyLoadedItems() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection()
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)
        
        // when
        sut.simulateSelection(section: singleSelectionSection1)
        inputController.loader.completeRetrieval(with: .none, at: 1)
        // then
        assertThat(sut, isRendering: [])
    }
    
    func test_loadItemsInSectionCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection()
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateSelection()
        inputController.loader.completeRetrieval(with: makeError())
        // then
        assertThat(sut, isRendering: items)
    }
    
    func test_loadItemsInSectionCompletion_rendersPreselectedItems() {
        let (sut, inputController) = makeSUT()
        let items = makeItems()
        inputController.preselectedItems = [items[1]]
        
        // when
        sut.simulateSelection()
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items, selectedItems: inputController.preselectedItems)
    }
    
    // MARK: - Single Selection Behaviour
    
    func test_selectingRenderedItemOnSingleSelectionType_removesSelectionIndicatorFromPreviouslySelectedItem() {
        let (sut, inputController) = makeSUT()
        let section = singleSelectionSection0
        let items = makeItems()

        sut.simulateSelection(section: singleSelectionSection0)
        inputController.loader.completeRetrieval(with: items)
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [0], for: section)

        // when
        sut.simulateItemSelection(at: singleSelectionSection1)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [1], for: section)
    }
    
    func test_deselectingRenderedItemOnSingleSelectionType_doesNotRemoveSelectionIndicator() {
        let (sut, inputController) = makeSUT()
        let section = singleSelectionSection0
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [0], for: section)

        // when
        sut.simulateItemDeselection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [0], for: section)
    }
    
    
    // MARK: - Multi Selection Behaviour
    
    func test_selectingRenderedItemOnMultiSelectionType_doesNotremoveSelectionIndicatorFromPreviouslySelectedItem() {
        let (sut, inputController) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()

        sut.simulateSelection(section: section)
        inputController.loader.completeRetrieval(with: items)
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        sut.simulateItemSelection(at: 1)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](0...1), for: section)
    }
    
    func test_deselectingRenderedItemOnMultiSelectionType_removesSelectionIndicator() {
        let (sut, inputController) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        sut.simulateItemSelection(at: 1)
        sut.simulateItemSelection(at: 2)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](0...2), for: section)

        // when
        sut.simulateItemDeselection(at: 0)
        sut.simulateItemDeselection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](1...2), for: section)

        // when
        sut.simulateItemDeselection(at: 1)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [2], for: section)

        // when
        sut.simulateItemSelection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [0, 2], for: section)
    }
    
    func test_selectingRenderedItemOnMultiSelectionType_removesMoreThanMaxAllowedSelectedItems() {
        let (sut, inputController) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        inputController.loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        sut.simulateItemSelection(at: 1)
        sut.simulateItemSelection(at: 2)
        sut.simulateItemSelection(at: 3)
        sut.simulateItemSelection(at: 4)
        sut.simulateItemSelection(at: 5)
        sut.simulateItemSelection(at: 6)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](0...6), for: section)

        // when
        sut.simulateItemSelection(at: 7)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](1...7), for: section)

        // when
        sut.simulateItemDeselection(at: 1)
        sut.simulateItemSelection(at: 1)
        sut.simulateItemDeselection(at: 1)
        sut.simulateItemSelection(at: 8)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](2...8), for: section)
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
        return (1...10).map { String($0)}
    }
    
    private func makeError() -> NSError {
        return NSError(domain: "error", code: -1)
    }
    
    private var singleSelectionSection0: Int {
        CLOCSelectableProperty.date.rawValue
    }
    
    private var singleSelectionSection1: Int {
        CLOCSelectableProperty.time.rawValue
    }
    
    private var singleSelectionSection2: Int {
        CLOCSelectableProperty.project.rawValue
    }

    private var multiSelectionSection: Int {
        CLOCSelectableProperty.repeatWeekDays.rawValue
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
            XCTAssertEqual(isPreselected, view!.isSelectedAndShowingIndicator, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isRenderingSelectionIndicatorForIndexes selectedIndexes: [Int], for section: Int, file: StaticString = #file, line: UInt = #line) {
        assertThat(sut, renderedSelectedIndexes: selectedIndexes, notExceedSelectionLimitFor: CLOCSelectableProperty(rawValue: section)!, file: file, line: line)
        
        for index in 0..<sut.numberOfRenderedItems {
            if selectedIndexes.contains(index) {
                assertThat(sut, isRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            } else {
                assertThat(sut, isNotRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            }
        }
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertTrue(view0!.isSelectedAndShowingIndicator, file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZTaskInputView, isNotRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertFalse(view0!.isSelectedAndShowingIndicator, file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZTaskInputView, renderedSelectedIndexes selectedIndexes: [Int], notExceedSelectionLimitFor section: CLOCSelectableProperty, file: StaticString = #file, line: UInt = #line) {
        var selectionLimit = 1
        if case .multiple(let max) = section.selectionType {
            selectionLimit = max
        }
        XCTAssertTrue(selectedIndexes.count <= selectionLimit, file: file, line: line)
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
    func simulateSelection(section: Int = 0) {
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
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
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
    
    var section: Int { 0 }
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
