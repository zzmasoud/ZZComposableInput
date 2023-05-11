//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import Foundation

public typealias PreSelectedItemsHandler = (Int) -> ([any AnyItem]?)

public final class ResourceListViewAdapter<Container: ItemsContainer, ResourceListController: ResourceListControllerProtocol>: ResourceListView {
    public typealias Item = Container.Item
    public typealias CellController = ResourceListController.ResourceListView.CellController
    public typealias ContainerMapper = (Int, [any AnyItem]?) -> Container
    public typealias CellControllerMapper = ([Item]) -> [CellController]
    public typealias ContainerCacheCallback = (Container, Int) -> Void
    
    private weak var controller: ResourceListController?
    private var container: Container?
    private let containerMapper: ContainerMapper
    private var cellControllerMapper: CellControllerMapper
    private var containerCacheCallback: ContainerCacheCallback
    
    public init(controller: ResourceListController, containerMapper: @escaping ContainerMapper, cellControllerMapper: @escaping CellControllerMapper, containerCacheCallback: @escaping ContainerCacheCallback) {
        self.controller = controller
        self.containerMapper = containerMapper
        self.cellControllerMapper = cellControllerMapper
        self.containerCacheCallback = containerCacheCallback
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        let section = viewModel.index
        // map data to container and then sync new container with selected items if exists
        let container = containerMapper(section, viewModel.items)
        containerCacheCallback(container, section)
        configuareResourceListViewBasedOn(container: container, in: controller)
        bind(container: container, to: controller)
        self.container = container
        
        let cellControllers = cellControllerMapper(container.items ?? [])
        pass(cellControllers: cellControllers, to: controller, using: container)
    }
    
    private func configuareResourceListViewBasedOn(container: Container, in controller: ResourceListController?) {
        controller?.resourceListView?.allowMultipleSelection(container.selectionType != .single)
        controller?.resourceListView?.allowAddNew(container.allowAdding)
    }
    
    private func pass(cellControllers: [CellController], to controller: ResourceListController?, using container: Container) {
        cellControllers.forEach { controller in
            controller.isSelected = {
                (container.selectedItems ?? []).contains(where: { item in
                    return item.hashValue == controller.id.hashValue
                })
            }
        }
        controller?.set(cellControllers: cellControllers)
    }
    
    private func bind(container: Container, to controller: ResourceListController?) {
        container.delegate = self
        controller?.delegate = self
    }
}
 
extension ResourceListViewAdapter: ItemsContainerDelegate {
    public func didDeselect(at index: Int) {
        controller?.resourceListView?.deselect(at: index)
    }
    
    public func newItemAdded(at index: Int) {
        guard let items = container?.items else { return }
        let cellControllers = cellControllerMapper(items)
        pass(cellControllers: cellControllers, to: controller, using: container!)
    }
}

extension ResourceListViewAdapter: ResourceListControllerDelegate {
    public func didSelectResource(at index: Int) {
        container?.select(at: index)
    }
    
    public func didDeselectResource(at index: Int) {
        container?.deselect(at: index)
    }
}
