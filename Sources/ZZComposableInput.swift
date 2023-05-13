//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class ZZComposableInput<SectionsController: SectionsControllerProtocol, ResourceListController: ResourceListControllerProtocol, Container: ItemsContainer> {
    public typealias Item = Container.Item
    public typealias CellController = ResourceListController.ResourceListView.CellController
    public typealias ContainerMapper = (Int, [any AnyItem]?) -> Container
    public typealias CellControllerMapper = ([Item]) -> [CellController]
    public typealias SectionChangeCallback = (Int) -> Void
    public typealias ToggleSelectionCallback = (Container) -> Void
    
    let sectionsController: SectionsController
    let resourceListController: ResourceListController
    
    public var onSectionChange: SectionChangeCallback?
    public var onToggleSelection: ToggleSelectionCallback?
    
    private lazy var selectionManager = InMemorySelectionManager<Container>()
    private var resourceListViewAdapter: ResourceListViewAdapter<Container, ResourceListController>? {
        didSet {
            resourceListViewAdapter?.onSelectionChange = { [weak self] in
                guard let self = self, let container = self.resourceListViewAdapter?.container else { return }
                self.onToggleSelection?(container)
            }
        }
    }
    
    public init(sectionsController: SectionsController, resourceListController: ResourceListController, itemsLoader: some ItemsLoader) {
        self.sectionsController = sectionsController
        self.resourceListController = resourceListController
    }
    
    public func start(withSections sections: [String], itemsLoader: some ItemsLoader, containerMapper: @escaping ContainerMapper, cellControllerMapper: @escaping CellControllerMapper) {
        self.resourceListViewAdapter = ResourceListViewAdapter(
            controller: self.resourceListController,
            containerMapper: containerMapper,
            cellControllerMapper: cellControllerMapper,
            containerCacheCallback: { [weak self] container, section in
                var ignorePreselected = false
                if self?.selectedItems(forSection: section) != nil { ignorePreselected = true }
                self?.selectionManager.sync(container: container, forSection: section, ignoringPreselection: ignorePreselected)
            })
        
        composedWith(
            sectionsController: sectionsController,
            itemsLoader: itemsLoader,
            sectionsPresenter: SectionsPresenter(
                titles: sections,
                view: WeakRefVirtualProxy(sectionsController)),
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: self.resourceListViewAdapter!,
                resourceController: resourceListController)
        )
    }
    
    private func composedWith(sectionsController: SectionsController, itemsLoader: some ItemsLoader, sectionsPresenter: SectionsPresenter, loadResourcePresenter: LoadResourcePresenter) {
        let presentationAdapter = LoadResourcePresentationAdapter(
            loader: itemsLoader)
        
        let sectionDelegateAdapter = SectionsControllerDelegateAdapter(sectionsPresenter: sectionsPresenter, sectionLoadCallback: { [weak self] index in presentationAdapter.selectSection(index: index)
            self?.onSectionChange?(index)
        })
        
        sectionsController.delegate = sectionDelegateAdapter
        presentationAdapter.presenter = loadResourcePresenter
    }
    
    private func makeLoadResourcePresenter(
        resourceListViewAdapter: ResourceListViewAdapter<Container, ResourceListController>,
        resourceController: ResourceListController
    ) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(resourceController),
            listView: resourceListViewAdapter)
    }
    
    public func add(newItem: Item) {
        resourceListViewAdapter?.container?.add(item: newItem)
    }
    
    public func selectedItems(forSection section: Int) -> [Item]? {
        return selectionManager.loadedContainers[section]?.selectedItems
    }
}
