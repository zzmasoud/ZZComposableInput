//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public typealias PreSelectedItemsHandler = (Int) -> ([AnyItem]?)
#warning("this typealias is just accepting DefaultItemsContainer, should fix it")
public typealias ContainerMapper = (Int, [AnyItem]?) -> DefaultItemsContainer

public final class ResourceListViewAdapter: ResourceListView {
    private weak var controller: ZZTaskInputView?
    private let containerMapper: ContainerMapper
    private var loadedContainers = [Int: DefaultItemsContainer]()
    
    public init(controller: ZZTaskInputView, containerMapper: @escaping ContainerMapper) {
        self.controller = controller
        self.containerMapper = containerMapper
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        let index = viewModel.index
        var container: DefaultItemsContainer
        
        if let loadedContainer = loadedContainers[index] {
            container = loadedContainer
        } else {
            container = containerMapper(index, viewModel.items)
            #warning("The selectionType should be based on the client's used entity not a fixed enum!")
        }
        
        #warning("How to set the tableview's allowMultipleSelection? Where and how? should it be handled in a presenter?")
        controller?.resourceListView.allowMultipleSelection(container.selectionType != .single)
        
        controller?.resourceListController.cellControllers = (container.items ?? []).map { item in
            #warning("how to fix this? (the selectable item might not have a title property! e.g. image-only cells! #ISSUE_01")
//            let cell = DefaultSelectableCell(text: item.title)
            let cell = DefaultSelectableCell(text: nil)
            return ZZSelectableCellController(
                id: item,
                dataSource: cell,
                delegate: cell,
                isSelected: {
                    container.selectedItems?.contains(item) ?? false
                })
        }
        
        controller?.onSelection = { [weak container] index in
            container?.select(at: index)
        }
        
        controller?.onDeselection = { [weak container] index in
            container?.unselect(at: index)
        }

        loadedContainers[viewModel.index] = container
    }
}

public final class DefaultSelectableCell: NSObject, UITableViewDataSource, UITableViewDelegate {
    let text: String?
    
    init(text: String?) {
        self.text = text
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZZSelectableCell.id, for: indexPath) as! ZZSelectableCell
        cell.textLabel?.text = text
        return cell
    }
}
