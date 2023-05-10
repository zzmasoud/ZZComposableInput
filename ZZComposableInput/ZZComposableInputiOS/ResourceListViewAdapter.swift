//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public typealias PreSelectedItemsHandler = (Int) -> ([any AnyItem]?)

public final class ResourceListViewAdapter<Container: ItemsContainer>: ResourceListView {
    public typealias Item = Container.Item
    public typealias ContainerMapper = (Int, [any AnyItem]?) -> Container
    public typealias CellControllerMapper = ([Item]) -> [SelectableCellController]
    
    private weak var controller: ZZComposableInput?
    private var container: Container?
    private let containerMapper: ContainerMapper
    private var cellControllerMapper: CellControllerMapper
    private let selectionManager = InMemorySelectionManager<Container>()
    
    public init(controller: ZZComposableInput, containerMapper: @escaping ContainerMapper, cellControllerMapper: @escaping CellControllerMapper) {
        self.controller = controller
        self.containerMapper = containerMapper
        self.cellControllerMapper = cellControllerMapper
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        let section = viewModel.index
        // map data to container and then sync new container with selected items if exists
        let container = containerMapper(section, viewModel.items)
        selectionManager.sync(container: container, forSection: section)
        configuareResourceListViewBasedOn(container: container, in: controller)
        bind(container: container, to: controller)
        self.container = container
        
        let cellControllers = cellControllerMapper(container.items ?? [])
        pass(cellControllers: cellControllers, to: controller, using: container)
    }
    
    private func configuareResourceListViewBasedOn(container: Container, in controller: ZZComposableInput?) {
        controller?.resourceListController.resourceListView?.allowMultipleSelection(container.selectionType != .single)
        controller?.resourceListController.resourceListView?.allowAddNew(container.allowAdding)
    }
    
    private func pass(cellControllers: [SelectableCellController], to controller: ZZComposableInput?, using container: Container) {
        cellControllers.forEach { controller in
            controller.isSelected = {
                (container.selectedItems ?? []).contains(where: { item in
                    return item.hashValue == controller.id.hashValue
                })
            }
        }
        controller?.resourceListController.set(cellControllers: cellControllers)
    }
    
    private func bind(container: Container, to controller: ZZComposableInput?) {
        container.delegate = self
        controller?.resourceListController.delegate = self
    }
    
    public func containerHasSelectedItems(at index: Int) -> Bool? {
        guard let container = selectionManager.loadedContainers[index] else { return nil }
        return !(container.selectedItems ?? []).isEmpty
    }
    
    public func getLoadedItems() -> [Int: [Item]?] {
        selectionManager.loadedContainers.reduce(into: [Int: [Item]?]()) { partialResult, object in
            partialResult[object.key] = object.value.selectedItems
        }
    }
}
 
extension ResourceListViewAdapter: ItemsContainerDelegate {
    public func didDeselect(at index: Int) {
        controller?.resourceListController?.resourceListView?.deselect(at: index)
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
