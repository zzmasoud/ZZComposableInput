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
    private var loadedContainers = [Int: Container]()
    
    public init(controller: ZZComposableInput, containerMapper: @escaping ContainerMapper, cellControllerMapper: @escaping CellControllerMapper) {
        self.controller = controller
        self.containerMapper = containerMapper
        self.cellControllerMapper = cellControllerMapper
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        let index = viewModel.index
        let container = containerMapper(index, viewModel.items)
        loadedContainers[index]?.selectedItems?.forEach({ item in
            if let index = container.items!.firstIndex(of: item) {
                container.select(at: index)
            }
        })
        
        #warning("#5 - How to set the tableview's allowMultipleSelection? Where and how? should it be handled in a presenter?")
        controller?.resourceListView.allowMultipleSelection(container.selectionType != .single)
        controller?.resourceListView.allowAddNew(container.allowAdding)
        
        let cellControllers = cellControllerMapper(container.items ?? [])
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
            container?.unselect(at: index)
        }

        loadedContainers[viewModel.index] = container
    }
    
    public func containerHasSelectedItems(at index: Int) -> Bool? {
        guard let container = loadedContainers[index] else { return nil }
        return !(container.selectedItems ?? []).isEmpty
    }
    
    public func getLoadedItems() -> [Int: [Item]?] {
        loadedContainers.reduce(into: [Int: [Item]?]()) { partialResult, object in
            partialResult[object.key] = object.value.selectedItems
        }
    }
}
