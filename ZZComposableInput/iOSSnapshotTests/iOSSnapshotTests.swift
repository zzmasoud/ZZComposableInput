//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput
@testable import ZZComposableInputiOS

final class iOSSnapshotTests: XCTestCase {
    
    func test_initiatedState() {
        let (sut, _) = makeSUT()
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Initial State")
    }
    
    func test_selectSection() {
        let section = 0
        let (sut, _) = makeSUT()
        
        sut.simulateSelection(section: section)
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Select First Section")
    }
    
    func test_loadedResources() {
        let section = 0
        let (sut, loader) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Load Resource of First Section")
    }
    
    func test_selectItemsInFirstSection() {
        let section = 0
        let (sut, loader) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        sut.simulateItemSelection(at: 2,1,0,2,2)
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Select Item of First Section")
    }
    
    func test_selectItemInSecondSection() {
        let section = 1
        let (sut, loader) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        sut.simulateItemSelection(at: 0,1,2,3,4)
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Select Item of Second Section")
        
        sut.simulateSelection(section: section-1)
        loader.completeRetrieval(with: makeItems(forSection: section-1))
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Back to First Section and Then Second")

    }
    
    func test_selectItemsInThirdSection() {
        let section = 2
        let (sut, loader) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
//        items = ["zz", "mas", "blah", "oud", "blah blah"]
        sut.simulateItemSelection(at: 4,2,0,1,3)
                
        sut.simulateSelection(section: section-1)
        loader.completeRetrieval(with: makeItems(forSection: section-1))
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "Select Items of Third Section")
    }
    
    
    // MARK: - Helpers
    
    private let sections = MockSection.allCases.map { $0.title }
    private typealias Container = DefaultItemsContainer<MockItem>
    
    private func makeSUT(preSelectedItems: [Int: [MockItem]]? = nil, file: StaticString = #file, line: UInt = #line) -> (sut: ZZComposableInputViewController, loader: ItemLoaderSpy) {
        let loader = ItemLoaderSpy()
        let inputController = makeInputViewController(
            onSelection: { index in
                
            }, onDeselection: { index in
                
            })
        
        let resourceListViewAdapter = ResourceListViewAdapter(
            controller: inputController,
            containerMapper: { [weak self] section, items in
                let preselectedItems = preSelectedItems?[section]
                return self!.containerMapper(section: section, items: items, preselectedItems: preselectedItems)
            },
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Self.self))
        let vc = storyboard.instantiateInitialViewController() as! ZZComposableInputViewController
        
        vc.sectionsController.sectionedView = MockSectionedView()
        vc.resourceListController.resourceListView = MockListView(onSelection: onSelection, onDeselection: onDeselection)
        
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
    
    private func cellControllerMapper(items: [MockItem]) -> [SelectableCellController] {
        return items.map { item in
            let view = MockCellController(model: item)
            return SelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
    }
    
    private enum MockSection: Int, CaseIterable {
        case domain = 0, special, letters
        
        var title: String {
            switch self {
            case .domain:
                return "Domain"
            case .special:
                return "Divider"
            case .letters:
                return "Username"
            }
        }
        
        var items: [MockItem] {
            var items = [String]()
            switch self {
            case .domain:
                items = ["Apple", "iOS", "Github"]
            case .special:
                items = ["#", "@", "!", "~", "/"]
            case .letters:
                items = ["zz", "mas", "blah", "oud", "blah blah"]
            }
            
            return items.map {.init($0)}
        }
        
        var selectionType: ItemsContainerSelectionType {
            switch self {
            case .letters: return .multiple(max: 3)
            default: return .single
            }
        }
    }
    
    func makeItems(forSection section: Int) -> [MockItem] {
        return MockSection(rawValue: section)!.items
    }
}

extension MockItem {
    init(_ title: String) {
        self.init(id: UUID(), title: title)
    }
}
