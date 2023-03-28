//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

final class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = UITableView()
    public var onSelection: ((Int) -> Void) = { _ in }
    public var onDeselection: ((Int) -> Void) = { _ in }
    
    public var view: UIView { return tableView }
    
    private var cellControllers: [ZZSelectableCellController] = []

    public func reloadData(with cellControllers: [ZZSelectableCellController]) {
        self.cellControllers = cellControllers
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
        tableView.reloadData()
    }
    
    func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(controller.isSelected(), animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}


final class CustomSegmentedControl: SectionedViewProtocol {
    let segmentedControl = UISegmentedControl()
    
    var selectedSectionIndex: Int {
        get { segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    
    var numberOfSections: Int { segmentedControl.numberOfSegments }
    
    func removeAllSections() {
        segmentedControl.removeAllSegments()
    }
    
    func insertSection(withTitle: String, at: Int) {
        segmentedControl.insertSegment(withTitle: withTitle, at: at, animated: false)
    }
    
    var view: UIControl { segmentedControl }
}

public struct MockItem: Hashable {
    let id: UUID
    public let title: String
    
    public init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let textParser = DefaultTextParser()
        let inputView = makeInputViewController()
                
        window?.rootViewController = ZZTaskInputViewComposer.composedWith(
            inputView: inputView,
            textParser: textParser,
            itemsLoader: MockItemsLoader(),
            sectionSelectionView: CustomSegmentedControl(),
            resourceListView: CustomTableView(),
            sectionsPresenter: SectionsPresenter(
                titles: Category.allCases.map { $0.title },
                view: WeakRefVirtualProxy(inputView.sectionsController!)
            ),
            loadResourcePresenter: makeLoadResourcePresenter(inputController: inputView)
        )
        window?.makeKeyAndVisible()
    }
    
    private func makeInputViewController() -> ZZTaskInputViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SceneDelegate.self))
        return storyboard.instantiateInitialViewController() as! ZZTaskInputViewController
    }
    
    private func makeLoadResourcePresenter(inputController: ZZTaskInputViewController) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputController),
            listView: ResourceListViewAdapter<DefaultItemsContainer>(
                controller: inputController,
                containerMapper: containerMapper))
    }
    
    private func containerMapper(section: Int, items: [AnyItem]?) -> DefaultItemsContainer {
        let preselectedItems = section == 0 ? [preselectedItem] : []
        return DefaultItemsContainer(
            items: items,
            preSelectedItems: preselectedItems,
            selectionType: Category.allCases[section].selectionType
        )
    }
}

let preselectedItem = MockItem(id: UUID(), title: "Avocado")

class MockItemsLoader: ItemsLoader {
    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        guard let category = Category(rawValue: section) else { fatalError("Failed to init Category enum case.") }
        switch category {
        case .fruits:
            completion(.success([
                .init(id: UUID(), title: "Orange"),
                .init(id: UUID(), title: "Apple"),
                .init(id: UUID(), title: "Watermelon"),
                .init(id: UUID(), title: "Banana"),
                preselectedItem,
                .init(id: UUID(), title: "Carrot"),
            ]))
        case .animals:
            completion(.success([
                MockItem.init(id: UUID(), title: "Fox"),
                .init(id: UUID(), title: "Tiger"),
                .init(id: UUID(), title: "Elephant"),
                .init(id: UUID(), title: "Panda"),
                .init(id: UUID(), title: "Eagle"),
                .init(id: UUID(), title: "Polar bear"),
                .init(id: UUID(), title: "Dolphin"),
                .init(id: UUID(), title: "Chimpanzee"),
                .init(id: UUID(), title: "Lion"),
                .init(id: UUID(), title: "Kangaroo"),

            ]))

        case .symbols:
            completion(.success([
                MockItem.init(id: UUID(), title: "Up"),
                .init(id: UUID(), title: "Down"),
                .init(id: UUID(), title: "Left"),
                .init(id: UUID(), title: "Right"),
            ]))
            
        default:
            completion(.failure(NSError(domain: "error", code: -1)))
        }
    }
}
