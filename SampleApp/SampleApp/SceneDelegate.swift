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
        let isSelected = controller.isSelected?() ?? false
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(isSelected, animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func allowAddNew(_ isOn: Bool) {
        // show a button e.g. in header or footer
    }
}


final class CustomSegmentedControl: NSObject, SectionedViewProtocol {
    var onSectionChange: (() -> Void)?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return view
    }()
    
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
    
    var view: UIView { segmentedControl }
    
    @objc private func valueChanged() {
        onSectionChange?()
    }
}

public struct MockItem: Hashable {
    let id: UUID
    public let title: String
    
    public init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}

public final class SectionsControllerDelegateAdapter: ZZSectionsControllerDelegate {
    private let sectionsPresenter: SectionsPresenter
    private var resourceViewTogglingPresenter: ResourceViewTogglingPresenter?
    
    public init(sectionsPresenter: SectionsPresenter, resourceViewTogglingPresenter: ResourceViewTogglingPresenter) {
        self.sectionsPresenter = sectionsPresenter
        self.resourceViewTogglingPresenter = resourceViewTogglingPresenter
    }
    
    public func didRequestSections() {
        sectionsPresenter.didRequestSections()
    }
    
    public func didSelectSection(at index: Int) {
        sectionsPresenter.didSelectSection(at: index)
        callTogglingPresenterOnlyOnce()
    }
    
    private func callTogglingPresenterOnlyOnce() {
        resourceViewTogglingPresenter?.selectSection()
        resourceViewTogglingPresenter = nil
    }
}

class CustomView: UIView, SectionedViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
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
                
        window?.rootViewController = ZZTaskInputViewComposer.composedWith(
            inputView: inputView,
            textParser: textParser,
            itemsLoader: MockItemsLoader(),
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
        window?.makeKeyAndVisible()
    }
    
    private func makeInputViewController() -> ZZTaskInputViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SceneDelegate.self))
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
    
    private func cellControllerMapper(items: [AnyItem]) -> [ZZSelectableCellController] {
        items.map { item in            
            let view = CustomView()
            return ZZSelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
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

extension ZZTaskInputViewController: ResourceViewToggling {
    public func display(_ viewModel: ResourceViewTogglingViewModel) {
        let targetView = resourceListView.view.superview
        if viewModel.isHidden {
            targetView?.isHidden = viewModel.isHidden
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveLinear) {
                targetView?.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
}
