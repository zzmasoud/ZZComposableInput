//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput
@testable import ZZComposableInputiOS

final class iOSIntegrationTests: XCTestCase {
    
    func test_x() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
    }

    // MARK: - Helpers
    
    private typealias Container = DefaultItemsContainer<MockItem>
    
    private func makeSUT() -> ZZComposableInputViewController {
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
                titles: ["A", "B", "C"],
                view: WeakRefVirtualProxy(inputController.sectionsController)),
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                inputController: inputController)
        )
        
        return sut
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
}

final class MockCellController: NSObject {
    private let model: MockItem
    private var cell: UITableViewCell?
    
    init(model: MockItem) {
        self.model = model
    }
}

extension MockCellController: SectionedViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell()
        cell?.textLabel?.text = model.title
        return cell!
    }

    private func releaseCellForReuse() {
        cell = nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
}
