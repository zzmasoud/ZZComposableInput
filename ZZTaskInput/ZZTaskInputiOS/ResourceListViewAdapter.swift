//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public typealias PreSelectedItemsHandler = (Int) -> ([NEED_TO_BE_GENERIC]?)

public final class ResourceListViewAdapter: ResourceListView {
    private weak var controller: ZZTaskInputView?
    private let preSelectedItemsHandler: PreSelectedItemsHandler
    private var loadedContainers = [Int: DefaultItemsContainer]()
    
    public init(controller: ZZTaskInputView, preSelectedItemsHandler: @escaping PreSelectedItemsHandler) {
        self.controller = controller
        self.preSelectedItemsHandler = preSelectedItemsHandler
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        var container: DefaultItemsContainer
        
        if let loadedContainer = loadedContainers[viewModel.index] {
            container = loadedContainer
        } else {
            let preSelectedItems = preSelectedItemsHandler(viewModel.index)
            container = DefaultItemsContainer(
                items: viewModel.items,
                preSelectedItems: preSelectedItems,
                selectionType: CLOCSelectableProperty(rawValue: viewModel.index)!.selectionType)
            #warning("The selectionType should be based on the client's used entity not a fixed enum!")
        }
        
        #warning("How to set the tableview's allowMultipleSelection? Where and how? should it be handled in a presenter?")
        controller?.resourceListView.allowMultipleSelection(container.selectionType != .single)
        
        controller?.resourceListController.cellControllers = (container.items ?? []).map { item in
            let cell = DefaultSelectableCell(text: item.title)
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
    let text: String
    
    init(text: String) {
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
