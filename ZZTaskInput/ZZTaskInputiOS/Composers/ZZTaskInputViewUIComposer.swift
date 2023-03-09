//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput

public typealias PreSelectedItemsHandler = (Int) -> ([NEED_TO_BE_GENERIC]?)

public final class ZZTaskInputViewComposer {
    public typealias ParsedText = (title: String, description: String?)
    private init() {}
    
    public static func composedWith(
        textParser: CLOCTextParser,
        itemsLoader: ZZItemsLoader,
        preSelectedItemsHandler: @escaping PreSelectedItemsHandler
    ) -> ZZTaskInputView {
        let itemsPresenter = ItemsPresenter(
            loader: itemsLoader,
            sections: ["date", "time", "project", "weekdaysRepeat"],
            indexMapper: { index in
                return CLOCSelectableProperty(rawValue: index)!
            })
 
        let sectionsController = ZZSectionsController(presenter: itemsPresenter)
        let inputView = ZZTaskInputView(sectionsController: sectionsController)
        
        itemsPresenter.loadingView = WeakRefVirtualProxy(sectionsController)
        itemsPresenter.listView = ItemsListViewAdapter(
            controller: inputView,
            preSelectedItemsHandler: preSelectedItemsHandler)
        
        inputView.onCompletion = { [weak inputView] in
            guard let text = inputView?.text else { return }
            let (title, description) = textParser.parse(text: text)
        }
        
        return inputView
    }
}

final class ItemsListViewAdapter: ItemsListView {
    private weak var controller: ZZTaskInputView?
    private let preSelectedItemsHandler: PreSelectedItemsHandler
    
    init(controller: ZZTaskInputView, preSelectedItemsHandler: @escaping PreSelectedItemsHandler) {
        self.controller = controller
        self.preSelectedItemsHandler = preSelectedItemsHandler
    }
    
    public func display(_ viewModel: ItemsListViewModel) {
        let preSelectedItems = preSelectedItemsHandler(viewModel.index)
        let container = CLOCItemsContainer(
            items: viewModel.items,
            preSelectedItems: preSelectedItems,
            selectionType: CLOCSelectableProperty(rawValue: viewModel.index)!.selectionType)
        
        controller?.cellControllers = (container.items ?? []).map { item in
            return ZZSelectableCellController(text: item.title, isSelected: {
                container.selectedItems?.contains(item) ?? false
            })
        }
        
        controller?.onSelection = { [weak container] index in
            container?.select(at: index)
        }
        
        controller?.onDeselection = { [weak container] index in
            container?.unselect(at: index)
        }
    }
}
