//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
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
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let sectionsController = ZZSectionsController(
            sections: ["date", "time", "project", "weekdaysRepeat"],
            loadSection: presentationAdapter.selectSection(index:))
        
        let storyboard = UIStoryboard(name: "ZZTaskInput", bundle: Bundle(for: ZZTaskInputView.self))
        let inputView = storyboard.instantiateInitialViewController() as! ZZTaskInputView
        inputView.sectionsController = sectionsController
        
        let itemsPresenter = ItemsPresenter(
            loadingView: WeakRefVirtualProxy(sectionsController),
            listView: ItemsListViewAdapter(
                controller: inputView,
                preSelectedItemsHandler: preSelectedItemsHandler))
        presentationAdapter.presenter = itemsPresenter
        
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


final class SectionSelectionPresentationAdapter {
    private let loader: ZZItemsLoader
    var presenter: ItemsPresenter?
    
    init(loader: ZZItemsLoader) {
        self.loader = loader
    }
    
    func selectSection(index: Int) {
        presenter?.didStartLoadingItems()
        loader.loadItems(for: index, completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.didFinishLoadingItems(with: items ?? [], at: index)
            case.failure(let error):
                self?.presenter?.didFinishLoadingItems(with: error)
            }
        })
    }
}
