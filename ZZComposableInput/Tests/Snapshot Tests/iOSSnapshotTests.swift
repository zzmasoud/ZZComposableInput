//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

final class iOSSnapshotTests: XCTestCase {
    
    func test_scenario() {
        let (sut, loader, viewController) = makeSUT()
        
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "0. Initial State")
    
        sut.simulateSelection(section: 0)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "1. Select First Section + Loading Resources")
    
        loader.completeRetrieval(with: makeItems(forSection: 0), at: 0)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "2. Resource Loaded for the First Section")
    
        sut.simulateItemSelection(at: 2,1,0,2,2)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "3. Select Item of First Section")
    
        sut.simulateSelection(section: 1)
        loader.completeRetrieval(with: makeItems(forSection: 1), at: 1)
        sut.simulateItemSelection(at: 0,1,2,3,4)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "4. Select Item of Second Section")
        
        sut.simulateSelection(section: 0)
        loader.completeRetrieval(with: makeItems(forSection: 0), at: 2)
        sut.simulateSelection(section: 1)
        loader.completeRetrieval(with: makeItems(forSection: 1), at: 3)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "5. Forth and Back Between First and Second Section")
    
        sut.simulateSelection(section: 2)
        loader.completeRetrieval(with: makeItems(forSection: 2), at: 4)
//        items = ["zz", "mas", "blah", "oud", "blah blah"]
        sut.simulateItemSelection(at: 4,2,0,1)
                
        sut.simulateSelection(section: 1)
        loader.completeRetrieval(with: makeItems(forSection: 1), at: 5)
        sut.simulateSelection(section: 2)
        loader.completeRetrieval(with: makeItems(forSection: 2), at: 6)
        sut.simulateItemSelection(at: 3)
        assert(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "6. Select Items of Third Section")
    }
    
    // MARK: - Helpers
    
    private let sections = MockSection.allCases.map { $0.title }
    private typealias Container = DefaultItemsContainer<MockItem>
    private typealias SUT = ZZComposableInput<MockSectionsController, MockResourceListController, Container>
    
    private func makeSUT(preSelectedItems: [Int: [MockItem]]? = nil, file: StaticString = #file, line: UInt = #line) -> (sut: SUT, loader: ItemLoaderSpy, viewController: UIViewController) {
        let viewController = makeInputViewController()
        viewController.loadViewIfNeeded()
        
        let loader = ItemLoaderSpy()
        let sectionsController = MockSectionsController(sectionedView: MockSectionedView(view: viewController.segmentedControl))
        let resourceListController = MockResourceListController(resourceListView: MockListView(tableView: viewController.tableView))
        
        let sut = SUT(sectionsController: sectionsController, resourceListController: resourceListController, itemsLoader: loader)
        sut.start(withSections: sections,
                  itemsLoader: loader) { [weak self] index, items in
            guard let self = self else { fatalError() }
            return self.containerMapper(section: index, items: items, preselectedItems: preSelectedItems?[index])
        } cellControllerMapper: { [weak self] items in
            guard let self = self else { fatalError() }
            return self.cellControllerMapper(items: items)
        }
        
        sectionsController.viewDidLoad()
        resourceListController.viewDidLoad()
        
        sut.onToggleSelection = { [weak sut, weak viewController] _ in
            let selectedItems0 = (sut?.selectedItems(forSection: 0) ?? []).map { $0.title }
            let selectedItems1 = (sut?.selectedItems(forSection: 1) ?? []).map { $0.title }
            let selectedItems2 = (sut?.selectedItems(forSection: 2) ?? []).map { $0.title }
            
            viewController?.log(selectedItems: [0: selectedItems0, 1: selectedItems1, 2: selectedItems2])
        }
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sectionsController, file: file, line: line)
        trackForMemoryLeaks(resourceListController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader, viewController)
    }
    
    private func containerMapper(section: Int, items: [any AnyItem]?, preselectedItems: [MockItem]? = nil) -> Container {
        let mockSection = MockSection(rawValue: section)!
        return Container(
            items: items as! [MockItem],
            preSelectedItems: preselectedItems,
            selectionType: mockSection.selectionType,
            allowAdding: false
        )
    }
    
    private func cellControllerMapper(items: [MockItem]) -> [SelectableCellController] {
        return items.map { item in
            let mockId = MockCellController(model: item)
            return SelectableCellController(id: mockId)
        }
    }

    private func makeInputViewController() -> CustomVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Self.self))
        return storyboard.instantiateInitialViewController() as! CustomVC
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
                items = ["Apple", "iOS", "Github.com"]
            case .special:
                items = ["#", "@", "!", "~", "/"]
            case .letters:
                items = ["zz", "mas", "blah", "oud", "blah blah"]
            }
            
            return items.map { .init(title: $0) }
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

struct MockItem: AnyItem {
    let title: String
    
    var hashValue: Int { return title.hashValue }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
