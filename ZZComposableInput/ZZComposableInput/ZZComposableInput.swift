//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public final class ZZComposableInput<SectionsController: SectionsControllerProtocol, ResourceListController: ResourceListControllerProtocol, Container: ItemsContainer> {
    public typealias Item = Container.Item
    public typealias CellController = ResourceListController.ResourceListView.CellController
    
    public typealias ContainerMapper = (Int, [any AnyItem]?) -> Container
    public typealias CellControllerMapper = ([Item]) -> [CellController]
    
    private let sectionsController: SectionsController
    private let resourceListController: ResourceListController
    
    private lazy var selectionManager = InMemorySelectionManager<Container>()
    
    public init(sectionsController: SectionsController, resourceListController: ResourceListController, itemsLoader: some ItemsLoader) {
        self.sectionsController = sectionsController
        self.resourceListController = resourceListController
    }
    
    public func start(withSections sections: [String], itemsLoader: some ItemsLoader, containerMapper: @escaping ContainerMapper, cellControllerMapper: @escaping CellControllerMapper) {
        let resourceListViewAdapter = ResourceListViewAdapter(
            controller: self.resourceListController,
            containerMapper: containerMapper,
            cellControllerMapper: cellControllerMapper,
            containerCacheCallback: { [weak self] container, section in
                self?.selectionManager.sync(container: container, forSection: section)
            })
        
        composedWith(
            sectionsController: sectionsController,
            itemsLoader: itemsLoader,
            sectionsPresenter: SectionsPresenter(
                titles: sections,
                view: WeakRefVirtualProxy(sectionsController)),
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                resourceController: resourceListController)
        )
    }
    
    private func composedWith(sectionsController: SectionsController, itemsLoader: some ItemsLoader, sectionsPresenter: SectionsPresenter, loadResourcePresenter: LoadResourcePresenter) {
        let presentationAdapter = LoadResourcePresentationAdapter(
            loader: itemsLoader)
        
        let sectionDelegateAdapter = SectionsControllerDelegateAdapter(sectionsPresenter: sectionsPresenter, sectionLoadCallback: presentationAdapter.selectSection(index:))
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
}
