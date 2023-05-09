//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput
@testable import ZZComposableInputiOS

final class iOSIntegrationTests: XCTestCase {
    
    func test_viewDidLoad_subviewsAreAdded() {
        let (sut, _) = makeSUT()
        
        XCTAssertNotNil(sut.sectionedView)
        XCTAssertNotNil(sut.resourceListView)
    }
    
    func test_sectionSelection_triggersLoader() {
        let section = 0
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)

        sut.simulateSelection(section: section)

        XCTAssertEqual(loader.loadCallCount, 1)
        XCTAssertEqual(loader.receivedMessages, [section])
    }
    
    func test_loadItemsInSectionCompletion_rendersSuccessfullyLoadedItems() {
        let section = 0
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
        let section = 0
        let items = makeItems()
        let (sut, loader) = makeSUT()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: items)

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeError(), at: 1)
        
        assertThat(sut, isRendering: [])
    }
    
    // MARK: - Helpers
    
    private let sections = ["A", "B", "C"]
    private typealias Container = DefaultItemsContainer<MockItem>
    
    private func makeSUT() -> (sut: ZZComposableInputViewController, loader: ItemLoaderSpy) {
        let loader = ItemLoaderSpy()
        let inputController = makeInputViewController(
            onSelection: { index in
            
        }, onDeselection: { index in
            
        })
        
        let resourceListViewAdapter = ResourceListViewAdapter(
            controller: inputController,
            containerMapper: containerMapper,
            cellControllerMapper: cellControllerMapper(items:))
        
        let sut = ZZTaskInputViewComposer.composedWith(
            inputView: inputController,
            itemsLoader: loader,
            sectionSelectionView: inputController.sectionedView,
            resourceListView: inputController.resourceListView,
            sectionsPresenter: SectionsPresenter(
                titles: sections,
                view: WeakRefVirtualProxy(inputController.sectionsController)),
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                inputController: inputController)
        )
        
        sut.loadViewIfNeeded()
        
        return (sut, loader)
    }
    
    private func makeLoadResourcePresenter(
        resourceListViewAdapter: ResourceListViewAdapter<Container>,
        inputController: ZZComposableInputViewController
    ) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputController),
            listView: resourceListViewAdapter)
    }
    
    private func makeInputViewController(onSelection: @escaping (Int) -> Void, onDeselection: @escaping (Int) -> Void) -> ZZComposableInputViewController {
        let sectionsController = SectionsController()
        sectionsController.sectionedViewContainer = UIView()
        sectionsController.sectionedView = MockSectionedView()
        
        let resourceController = ResourceListController()
        resourceController.listViewContainer = UIView()
        resourceController.resourceListView = MockListView(onSelection: onSelection, onDeselection: onDeselection)
        
        let vc = ZZComposableInputViewController()
        vc.sectionsController = sectionsController
        vc.resourceListController = resourceController
        
        return vc
    }
    
    private func containerMapper(section: Int, items: [any AnyItem]?) -> Container {
        let preselectedItems = [MockItem]()
        return Container(
            items: items as! [MockItem]?,
            preSelectedItems: preselectedItems,
            selectionType: .single,
            allowAdding: false
        )
    }
    
    private func cellControllerMapper(items: [MockItem]) -> [SelectableCellController] {
        return items.map { item in
            let view = MockCellController(model: item)
            return SelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
    }
    
    private func assertThat(_ sut: ZZComposableInputViewController, isRendering items: [Container.Item], selectedItems: [Container.Item]? = nil, file: StaticString = #file, line: UInt = #line) {
        sut.sectionedView.view.enforceLayoutCycle()

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
    
    private func assertThat(_ sut: ZZComposableInputViewController, isRenderingSelectionIndicatorForIndexes selectedIndexes: [Int], for section: Int, file: StaticString = #file, line: UInt = #line) {
        assertThat(sut, renderedSelectedIndexes: selectedIndexes, notExceedSelectionLimit: 1, file: file, line: line)
        
        for index in 0..<sut.numberOfRenderedItems {
            if selectedIndexes.contains(index) {
                assertThat(sut, isRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            } else {
                assertThat(sut, isNotRenderingSelectedIndicatorElementsAt: index, file: file, line: line)
            }
        }
    }
    
    private func assertThat(_ sut: ZZComposableInputViewController, isRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertTrue(view0!.isSelectedAndShowingIndicator, "expected to have selection indicator in the view but not found", file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZComposableInputViewController, isNotRenderingSelectedIndicatorElementsAt index: Int, file: StaticString = #file, line: UInt = #line) {
        let view0 = sut.itemView(at: index)
        XCTAssertNotNil(view0, file: file, line: line)
        XCTAssertFalse(view0!.isSelectedAndShowingIndicator, "expected to have no selection indicator in the view but found it", file: file, line: line)
    }
    
    private func assertThat(_ sut: ZZComposableInputViewController, renderedSelectedIndexes selectedIndexes: [Int], notExceedSelectionLimit selectionLimit: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(selectedIndexes.count <= selectionLimit, "expected single selection but got \(selectedIndexes.count) items selected", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
