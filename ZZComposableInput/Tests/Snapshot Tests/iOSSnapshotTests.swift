//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

final class iOSSnapshotTests: XCTestCase {
    
    func test_initiatedState() {
        let (_, _, viewController) = makeSUT()
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Initial State")
    }
    
    func test_selectSection() {
        let section = 0
        let (sut, _, viewController) = makeSUT()
        
        sut.simulateSelection(section: section)
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Select First Section")
    }
    
    func test_loadedResources() {
        let section = 0
        let (sut, loader, viewController) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Load Resource of First Section")
    }
    
    func test_selectItemsInFirstSection() {
        let section = 0
        let (sut, loader, viewController) = makeSUT()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        sut.simulateItemSelection(at: 2,1,0,2,2)
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Select Item of First Section")
    }
    
    func test_selectItemInSecondSection() {
        let section = 1
        let (sut, loader, viewController) = makeSUT()

        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        sut.simulateItemSelection(at: 0,1,2,3,4)
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Select Item of Second Section")
        
        sut.simulateSelection(section: section-1)
        loader.completeRetrieval(with: makeItems(forSection: section-1))
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Back to First Section and Then Second")

    }
    
    func test_selectItemsInThirdSection() {
        let section = 2
        let (sut, loader, viewController) = makeSUT()
        
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
//        items = ["zz", "mas", "blah", "oud", "blah blah"]
        sut.simulateItemSelection(at: 4,2,0,1,3)
                
        sut.simulateSelection(section: section-1)
        loader.completeRetrieval(with: makeItems(forSection: section-1))
        sut.simulateSelection(section: section)
        loader.completeRetrieval(with: makeItems(forSection: section))
        
        record(snapshot: viewController.snapshot(for: .iPhone13(style: .light)), named: "Select Items of Third Section")
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
                  itemsLoader: loader) { index, items in
            self.containerMapper(section: index, items: items, preselectedItems: preSelectedItems?[index])
        } cellControllerMapper: { items in
            self.cellControllerMapper(items: items)
        }
        
        sectionsController.viewDidLoad()
        resourceListController.viewDidLoad()
        
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
