//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import UIKit
import ZZTaskInput
import ZZTaskInputiOS
@testable import SampleApp

class ZZTaskInputViewControllerTests: XCTestCase {
    
    func test_loadItemsActions_requestSelectFromloader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)
        
        sut.simulateSelection()
        loader.completeRetrieval(with: makeItems())
        XCTAssertEqual(loader.loadCallCount, 1)
    }

    #warning("This test isn't time benfical, need to think more about it.")
    func test_didMoveToWindow_makesTextFieldFirstResponder() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.isTextInputFirstResponder)
        
        //  When you call becomeFirstResponder() on a text input, it does not immediately become the first responder. The actual first responder will be set at the next run loop iteration. This means that if you immediately check the value of isFirstResponder after calling becomeFirstResponder(), it may still be false.
        // Create an expectation that the text input will become the first responder
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isFirstResponder == true"),
            object: sut.textInput
        )

        addToWindow(sut)


        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(sut.isTextInputFirstResponder)
    }
    
    func test_sectionsView_rendersSectionsAndNoSectionSelectedAtFirst() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.numberOfRenderedSections, Category.allCases.count)
        XCTAssertEqual(sut.selectedSectionIndex, -1)
    }
    
    func test_selectedSectionText_isVisibleWhenItemsIsLoaded() {
        let (sut, loader) = makeSUT()
        XCTAssertTrue(sut.isSectionTextHidden)
 
        sut.simulateSelection()
        loader.completeRetrieval(with: makeItems())
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: singleSelectionSection0)
        XCTAssertFalse(sut.isSectionTextHidden)
        XCTAssertEqual(sut.sectionText, Category.allCases[singleSelectionSection0].title)

        loader.completeRetrieval(with: .none, at: 1)
        XCTAssertFalse(sut.isSectionTextHidden)

        sut.simulateSelection(section: singleSelectionSection1)
        XCTAssertEqual(sut.sectionText, Category.allCases[singleSelectionSection1].title)
        XCTAssertFalse(sut.isSectionTextHidden)

        loader.completeRetrieval(with: makeError(), at: 2)
        XCTAssertFalse(sut.isSectionTextHidden)
    }
    
    func test_loadItemsInSectionCompletion_rendersSuccessfullyLoadedItems() {
        let (sut, loader) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection()
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)
        
        // when
        sut.simulateSelection(section: singleSelectionSection1)
        loader.completeRetrieval(with: .none, at: 1)
        // then
        assertThat(sut, isRendering: [])
    }
    
    func test_loadItemsInSectionCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, loader) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection()
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateSelection()
        loader.completeRetrieval(with: makeError())
        // then
        assertThat(sut, isRendering: items)
    }
    
    func test_loadItemsInSectionCompletion_removesPreviouslyRenderedItemsOnNewSectionError() {
        let (sut, loader) = makeSUT()
        let items = makeItems()

        // when
        sut.simulateSelection()
        loader.completeRetrieval(with: items)
        
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateSelection(section: 1)
        loader.completeRetrieval(with: makeError(), at: 1)
        
        // then
        assertThat(sut, isRendering: [])
    }
    
    func test_loadItemsInSectionCompletion_rendersPreselectedItems() {
        let items = makeItems()
        let preSelectedItems = [items[1]] as? [AnyItem]
        let (sut, loader) = makeSUT(preSelectedItems: preSelectedItems)
        
        // when
        sut.simulateSelection()
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items, selectedItems: preSelectedItems)
     }
    
    func test_selectingSection_keepsSelectedItemsOnPreviouslyChangedSection() {
        let section0Items = makeItems()
        let section1Items = makeItems()
        let preSelectedItems = [section0Items[1]] as? [AnyItem]
        let (sut, loader) = makeSUT(preSelectedItems: preSelectedItems)
        
        // when
        sut.simulateSelection(section: singleSelectionSection0)
        loader.completeRetrieval(with: section0Items)
        sut.simulateItemSelection(at: 0)
        sut.simulateItemSelection(at: 1)
        sut.simulateItemSelection(at: 2)

        // then
        assertThat(sut, isRendering: section0Items, selectedItems: [section0Items[2]])
        
        // when
        sut.simulateSelection(section: multiSelectionSection)
        loader.completeRetrieval(with: section1Items, at: 1)
        sut.simulateItemSelection(at: 0, 1, 2)
        
        // then
        assertThat(sut, isRendering: section1Items, selectedItems: Array(section1Items[0...2]))
        
        // when selecting the previously section again
        sut.simulateSelection(section: singleSelectionSection0)
        loader.completeRetrieval(with: section0Items)

        // then
        assertThat(sut, isRendering: section0Items, selectedItems: [section0Items[2]])
    }
    
    func test_listViewSelectionLimit_changesWithSection() {
        let (sut, loader) = makeSUT()
        
        // when
        sut.simulateSelection(section: singleSelectionSection0)
        loader.completeRetrieval(with: makeError(), at: 0)
        
        // then
        XCTAssertFalse(sut.isMultiSelection)
        
        // when
        sut.simulateSelection(section: multiSelectionSection)
        loader.completeRetrieval(with: makeError(), at: 1)

        // then
        XCTAssertTrue(sut.isMultiSelection)
    }
    
    // MARK: - Single Selection Behaviour
    
    func test_selectingRenderedItemOnSingleSelectionType_removesSelectionIndicatorFromPreviouslySelectedItem() {
        let (sut, loader) = makeSUT()
        let section = singleSelectionSection0
        let items = makeItems()

        sut.simulateSelection(section: singleSelectionSection0)
        loader.completeRetrieval(with: items)
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [0], for: section)

        // when
        sut.simulateItemSelection(at: 1)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [1], for: section)
    }
    
    func test_deselectingRenderedItemOnSingleSelectionType_doesNotRemoveSelectionIndicator() {
        let (sut, loader) = makeSUT()
        let section = singleSelectionSection0
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
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
        let (sut, loader) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0)
        sut.simulateItemSelection(at: 1)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](0...1), for: section)
    }
    
    func test_deselectingRenderedItemOnMultiSelectionType_removesSelectionIndicator() {
        let (sut, loader) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        // when
        sut.simulateItemSelection(at: 0,1,2)
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
        let (sut, loader) = makeSUT()
        let section = multiSelectionSection
        let items = makeItems()
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)

        #warning("In this test, every action depends on Category eunm case, e.g. maximum limit. should fix it. For example in the *** assertion, it fails if the max limit is bigger than 7")
        
        // when
        sut.simulateItemSelection(at: 0,1,2,3,4,5,6)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](0...6), for: section)

        // when
        sut.simulateItemSelection(at: 7)
        // then
        #warning("***")
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
    
    private func makeSUT(preSelectedItems: [AnyItem]? = nil, file: StaticString = #file, line: UInt = #line) -> (sut: ZZTaskInputViewController, loader: ItemLoaderSpy) {
        let spyLoader = ItemLoaderSpy()
        let loader = DefaultItemsLoader(loader: spyLoader)
        let inputView = makeInputViewController()
        
        let resourceViewTogglingPresenter = ResourceViewTogglingPresenter(view: WeakRefVirtualProxy(inputView))
        inputView.onViewDidLoad = { [weak self] in
            resourceViewTogglingPresenter.viewDidLoad()
        }
        
        let sectionsPresenter = SectionsPresenter(
            titles: Category.allCases.map { $0.title },
            view: WeakRefVirtualProxy(inputView.sectionsController!)
        )
        
        let resourceListViewAdapter = ResourceListViewAdapter<DefaultItemsContainer>(
            controller: inputView,
            containerMapper: containerMapper,
            cellControllerMapper: cellControllerMapper)

        let sut = ZZTaskInputViewComposer.composedWith(
            inputView: inputView,
            textParser: DefaultTextParser(),
            itemsLoader: loader,
            sectionSelectionView: CustomSegmentedControl(),
            resourceListView: CustomTableView(),
            sectionsPresenter: sectionsPresenter,
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                inputController: inputView
            ),
            sectionsControllerDelegate: SectionsControllerDelegateAdapter(
                sectionsPresenter: sectionsPresenter,
                resourceViewTogglingPresenter: resourceViewTogglingPresenter
            )
        )
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        sut.loadViewIfNeeded()
        
        return (sut, spyLoader)
    }
    
    private func makeInputViewController() -> ZZTaskInputViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SampleApp.SceneDelegate.self))
        return storyboard.instantiateInitialViewController() as! ZZTaskInputViewController
    }
    
    private func makeLoadResourcePresenter(
        resourceListViewAdapter: ResourceListViewAdapter<DefaultItemsContainer>,
        inputController: ZZTaskInputViewController
    ) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputController),
            listView: resourceListViewAdapter)
    }

    private func containerMapper(section: Int, items: [AnyItem]?) -> DefaultItemsContainer {
        let preselectedItems = section == 0 ? [preselectedItem] : []
        let section = Category.allCases[section]
        return DefaultItemsContainer(
            items: items,
            preSelectedItems: preselectedItems,
            selectionType: section.selectionType, allowAdding: section != .fruits
        )
    }

    private func cellControllerMapper(items: [AnyItem]) -> [ZZSelectableCellController] {
        items.map { item in
            let view = CustomCellView()
            return ZZSelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
    }

    private var singleSelectionSection0: Int {
        Category.symbols.rawValue
    }
    
    private var singleSelectionSection1: Int {
        Category.flags.rawValue
    }

    private var multiSelectionSection: Int {
        Category.animals.rawValue
    }
    
    private func addToWindow(_ sut: ZZTaskInputViewController) {
        let window = UIWindow()
        window.addSubview(sut.view)
    }
    
    private func assertThat(_ sut: ZZTaskInputViewController, isRendering items: [ItemLoaderSpy.Item], selectedItems: [ItemLoaderSpy.Item]? = nil, file: StaticString = #file, line: UInt = #line) {
        sut.tableView.enforceLayoutCycle()

        guard sut.numberOfRenderedItems == items.count else {
            return XCTFail("expected \(items.count) items but got \(sut.numberOfRenderedItems) items!", file: file, line: line)
        }
        
        for (index, item) in items.enumerated() {
            let view = sut.itemView(at: index)
            XCTAssertNotNil(view, file: file, line: line)
            #warning("casting AnyHashable to mock item, related to ISSUE_01")
//            if let text = (item as? MockItem)?.title {
//                XCTAssertEqual(view?.textLabel?.text, text, file: file, line: line)
//            }
            let isPreselected = selectedItems?.contains(item) ?? false
            XCTAssertEqual(isPreselected, view!.isSelectedAndShowingIndicator, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    private func assertThat(_ sut: ZZTaskInputViewController, isRenderingSelectionIndicatorForIndexes selectedIndexes: [Int], for section: Int, file: StaticString = #file, line: UInt = #line) {
        assertThat(sut, renderedSelectedIndexes: selectedIndexes, notExceedSelectionLimitFor: Category(rawValue: section)!, file: file, line: line)
        
        for index in 0..<sut.numberOfRenderedItems {
            if selectedIndexes.contains(index) {
                assertThat(sut, isRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            } else {
                assertThat(sut, isNotRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            }
        }
    }
    
    private func assertThat(_ sut: ZZTaskInputViewController, isRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertTrue(view0!.isSelectedAndShowingIndicator, "expected to have selection indicator in the view but not found", file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZTaskInputViewController, isNotRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertFalse(view0!.isSelectedAndShowingIndicator, "expected to have no selection indicator in the view but found it", file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZTaskInputViewController, renderedSelectedIndexes selectedIndexes: [Int], notExceedSelectionLimitFor section: SampleApp.Category, file: StaticString = #file, line: UInt = #line) {
        var selectionLimit = 1
        if case .multiple(let max) = section.selectionType {
            selectionLimit = max
        }
        XCTAssertTrue(selectedIndexes.count <= selectionLimit, "expected selection type: \(section.selectionType) but got \(selectedIndexes.count) items selected", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
