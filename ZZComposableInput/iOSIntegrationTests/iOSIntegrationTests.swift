//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
@testable import ZZComposableInput
@testable import ZZComposableInputiOS

final class iOSIntegrationTests: XCTestCase {
    
    func test_viewDidLoad_subviewsAreAdded() {
        let (sut, _) = makeSUT()
        
        XCTAssertNotNil(sut.sectionedView)
        XCTAssertNotNil(sut.resourceListView)
    }
    
    func test_sectionSelection_triggersLoader() {
        let section = 1
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)

        sut.simulateSelection(section: section)

        XCTAssertEqual(loader.loadCallCount, 1)
        XCTAssertEqual(loader.receivedMessages, [section])
    }
    
    func test_loadItemsInSectionCompletion_rendersSuccessfullyLoadedItems() {
        let section = 1
        let items = makeItems()
        let (sut, loader) = makeSUT()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
        
        assertThat(sut, isRendering: items)
        
        sut.simulateSelection(section: section+1)
        loader.completeRetrieval(with: [], at: 1)
        
        assertThat(sut, isRendering: [])
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeError(), at: 2)
        
        assertThat(sut, isRendering: [])
    }

    func test_loadItemsInSectionCompletion_removesPreviouslyRenderedItemsOnNewSectionError() {
        let section = 1
        let items = makeItems()
        let (sut, loader) = makeSUT()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeError(), at: 1)
        
        assertThat(sut, isRendering: [])
    }
    
    func test_loadItemsInSectionCompletion_rendersPreselectedItems() {
        let section = 1
        let items = makeItems()
        let preSelectedItems = [section: [items[1]]]
        let (sut, loader) = makeSUT(preSelectedItems: preSelectedItems)
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)

        assertThat(sut, isRendering: items, selectedItems: preSelectedItems[section]!)
     }
    
    func test_selectingSection_keepsSelectedItemsOnPreviouslyChangedSection() {
        let section = 1
        let section0Items = makeItems()
        let section1Items = makeItems()
        let preSelectedItems = [section: [section0Items[1]]]
        let (sut, loader) = makeSUT(preSelectedItems: preSelectedItems)
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: section0Items)
        sut.simulateItemSelection(at: 2)

        // then
        assertThat(sut, isRendering: section0Items, selectedItems: [section0Items[2]])
        
        // when
        sut.simulateSelection(section: section+1)
        loader.completeRetrieval(with: section1Items, at: 1)
        sut.simulateItemSelection(at: 0, 1)
        
        // then
        assertThat(sut, isRendering: section1Items, selectedItems: Array(section1Items[0...1]))

        // when selecting the previous section again
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: section0Items, at: 2)

        // then
        assertThat(sut, isRendering: section0Items, selectedItems: [section0Items[2]])
    }
    
    func test_listViewSelectionLimit_changesWithSection() {
        let section = 1
        let (sut, loader) = makeSUT()
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeError(), at: 0)
        
        // then
        XCTAssertFalse(sut.isMultiSelection)
        
        // when
        sut.simulateSelection(section: section+1)
        loader.completeRetrieval(with: makeError(), at: 1)

        // then
        XCTAssertTrue(sut.isMultiSelection)
    }
    
    // MARK: - Single Selection Behaviour
    
    func test_selectingRenderedItemOnSingleSelectionType_removesSelectionIndicatorFromPreviouslySelectedItem() {
        let section = 1
        let items = makeItems()
        let (sut, loader) = makeSUT()

        sut.simulateSelection(section: section)
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
        let section = 1
        let items = makeItems()
        let (sut, loader) = makeSUT()
        
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
        let section = 3
        let items = makeItems()
        let (sut, loader) = makeSUT()

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
        let section = 3
        let items = makeItems()
        let (sut, loader) = makeSUT()
        
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
    
    #warning("This test is passing, while the snapshot tests recognized wrong logic. (max selection of a container should deselect previous items from the UI too.)")
    func test_selectingRenderedItemOnMultiSelectionType_removesMoreThanMaxAllowedSelectedItems() {
        let section = 3
        let items = makeItems()
        let (sut, loader) = makeSUT()
        
        // when
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)
        // then
        assertThat(sut, isRendering: items)
        
        // when
        sut.simulateItemSelection(at: 0,1,2,3,4,5,6)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](4...6), for: section)

        // when
        sut.simulateItemSelection(at: 7)
        // then

        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](5...7), for: section)

        // when
        sut.simulateItemDeselection(at: 1)
        sut.simulateItemSelection(at: 1)
        sut.simulateItemDeselection(at: 1)
        sut.simulateItemSelection(at: 8)
        // then
        assertThat(sut, isRenderingSelectionIndicatorForIndexes: [Int](6...8), for: section)
    }
    
    // MARK: - Helpers
    
    private let sections = MockSection.allCases.map { $0.title }
    private typealias Container = DefaultItemsContainer<MockItem>
    private typealias RView = MockListView
    private typealias RController = ResourceController<RView>
    private typealias SUT = ZZComposableInputViewController<RController, RView>
    
    private func makeSUT(preSelectedItems: [Int: [MockItem]]? = nil, file: StaticString = #file, line: UInt = #line) -> (sut: SUT, loader: ItemLoaderSpy) {
        let loader = ItemLoaderSpy()
        let selectionManager = InMemorySelectionManager<Container>()
        let inputController = makeInputViewController(
            onSelection: { index in
            
        }, onDeselection: { index in
            
        })
        
        let resourceListViewAdapter = ResourceListViewAdapter(
            controller: inputController.resourceListController,
            containerMapper: { [weak self] section, items in
                let preselectedItems = preSelectedItems?[section]
                return self!.containerMapper(section: section, items: items, preselectedItems: preselectedItems)
            },
            cellControllerMapper: cellControllerMapper(items:),
            containerCacheCallback: { container, section in
                selectionManager.sync(container: container, forSection: section)
            }
        )
        
        let sut = ZZComposableInputComposer.composedWith(
            inputView: inputController,
            itemsLoader: loader,
            sectionsPresenter: SectionsPresenter(
                titles: sections,
                view: WeakRefVirtualProxy(inputController._sectionsController)),
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                inputController: inputController)
        )
        
        sut.loadViewIfNeeded()
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(resourceListViewAdapter, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func makeLoadResourcePresenter(
        resourceListViewAdapter: ResourceListViewAdapter<Container, RController>,
        inputController: SUT
    ) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputController),
            listView: resourceListViewAdapter)
    }
    
    private func makeInputViewController(onSelection: @escaping (Int) -> Void, onDeselection: @escaping (Int) -> Void) -> SUT {
        let sectionsController = SectionsController()
        sectionsController.sectionedViewContainer = UIView()
        sectionsController.sectionedView = MockSectionedView()
        
        let resourceController = ResourceController<MockListView>()
        resourceController.listViewContainer = UIView()
        resourceController.resourceListView = MockListView(onSelection: onSelection, onDeselection: onDeselection)
        
        let vc = SUT()
        vc._sectionsController = sectionsController
        vc._resourceListController = resourceController
        
        return vc
    }
    
    private func containerMapper(section: Int, items: [any AnyItem]?, preselectedItems: [MockItem]? = nil) -> Container {
        let mockSection = MockSection(rawValue: section)!
        return Container(
            items: items as! [MockItem]?,
            preSelectedItems: preselectedItems,
            selectionType: mockSection.selectionType,
            allowAdding: false
        )
    }
    
    private func cellControllerMapper(items: [MockItem]) -> [UIKitSelectableCellController] {
        return items.map { item in
            let view = MockCellController(model: item)
            return UIKitSelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
    }
    
    private func assertThat(_ sut: SUT, isRendering items: [Container.Item], selectedItems: [Container.Item]? = nil, file: StaticString = #file, line: UInt = #line) {
        (sut.sectionedView.view as! UIView).enforceLayoutCycle()

        guard sut.numberOfRenderedItems == items.count else {
            return XCTFail("expected \(items.count) items but got \(sut.numberOfRenderedItems) items!", file: file, line: line)
        }
        
        for (index, item) in items.enumerated() {
            let view = sut.itemView(at: index)
            XCTAssertNotNil(view, file: file, line: line)
            let isPreselected = selectedItems?.contains(item) ?? false
            XCTAssertEqual(isPreselected, view!.isSelectedAndShowingIndicator, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    private func assertThat(_ sut: SUT, isRenderingSelectionIndicatorForIndexes selectedIndexes: [Int], for section: Int, file: StaticString = #file, line: UInt = #line) {
        let mockSection = MockSection(rawValue: section)!
        var selectionLimit = 1
        if case .multiple(let max) = mockSection.selectionType {
            selectionLimit = max
        }
        assertThat(sut, renderedSelectedIndexes: selectedIndexes, notExceedSelectionLimit: selectionLimit, file: file, line: line)
        
        for index in 0..<sut.numberOfRenderedItems {
            if selectedIndexes.contains(index) {
                assertThat(sut, isRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            } else {
                assertThat(sut, isNotRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            }
        }
    }
    
    private func assertThat(_ sut: SUT, isRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertTrue(view0!.isSelectedAndShowingIndicator, "expected to have selection indicator in the view but not found", file: file, line: line)
    }
    
    private func assertThat(_ sut: SUT, isNotRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertFalse(view0!.isSelectedAndShowingIndicator, "expected to have no selection indicator in the view but found it", file: file, line: line)
    }
    
    private func assertThat(_ sut: SUT, renderedSelectedIndexes selectedIndexes: [Int], notExceedSelectionLimit selectionLimit: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(selectedIndexes.count <= selectionLimit, "expected maximum \(selectionLimit) selection but got \(selectedIndexes.count) items selected.", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
