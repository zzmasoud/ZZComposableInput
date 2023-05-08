//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public typealias PreSelectedItemsHandler = (Int) -> ([any AnyItem]?)

public final class ResourceListViewAdapter<Container: ItemsContainer>: ResourceListView {
    public typealias Item = Container.Item
    public typealias ContainerMapper = (Int, [any AnyItem]?) -> Container
    public typealias CellControllerMapper = ([Item]) -> [ZZSelectableCellController]

    private weak var controller: ZZComposableInput?
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
        
        let cellControllers = cellControllerMapper(container.items ?? [])
        pass(cellControllers: cellControllers, to: controller, using: container)
    }
    
    private func configuareResourceListViewBasedOn(container: Container, in controller: ZZComposableInput?) {
        controller?.resourceListView.allowMultipleSelection(container.selectionType != .single)
        controller?.resourceListView.allowAddNew(container.allowAdding)
    }
    
    private func pass(cellControllers: [ZZSelectableCellController], to controller: ZZComposableInput?, using container: Container) {
        cellControllers.forEach { controller in
            controller.isSelected = {
                (container.selectedItems ?? []).contains(where: { item in
                    return item.hashValue == controller.id.hashValue
                })
            }
        }
        controller?.resourceListController.cellControllers = cellControllers

        controller?.onSelection = { [weak container] index in
            container?.select(at: index)
        }
        
        controller?.onDeselection = { [weak container] index in
            container?.deselect(at: index)
        }
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
