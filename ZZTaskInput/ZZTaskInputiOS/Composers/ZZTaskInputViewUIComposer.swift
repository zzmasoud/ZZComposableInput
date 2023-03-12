//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public typealias PreSelectedItemsHandler = (Int) -> ([NEED_TO_BE_GENERIC]?)

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith(
        textParser: any ZZTextParser,
        itemsLoader: ZZItemsLoader,
        preSelectedItemsHandler: @escaping PreSelectedItemsHandler
    ) -> ZZTaskInputView {
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let storyboard = UIStoryboard(name: "ZZTaskInput", bundle: Bundle(for: ZZTaskInputView.self))
        let inputView = storyboard.instantiateInitialViewController() as! ZZTaskInputView
        let sectionsController = inputView.sectionsController!
        #warning("should get sections title from presenter and be set in the composition root. but still setting a useless sections property of SectionsController which will later be used by a function call after view did load. how to fix this?")
//        sectionsController.sections = ItemsPresenter.section
        #warning("Fixed it by using a new presenter for sections. is it correct?")
        sectionsController.delegate = SectionsPresenter(
            titles: ["date", "time", "project", "repeatDays"],
            view: WeakRefVirtualProxy(sectionsController))
        
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        
        let loadResourcePresenter = LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputView),
            listView: ResourceListViewAdapter(
                controller: inputView,
                preSelectedItemsHandler: preSelectedItemsHandler))
        presentationAdapter.presenter = loadResourcePresenter
        
        inputView.onCompletion = { [weak inputView] in
            guard let text = inputView?.text else { return }
            let _ = textParser.parse(text: text)
        }
        
        return inputView
    }
}

final class ResourceListViewAdapter: ResourceListView {
    private weak var controller: ZZTaskInputView?
    private let preSelectedItemsHandler: PreSelectedItemsHandler
    private var loadedContainers = [Int: CLOCItemsContainer]()
    
    init(controller: ZZTaskInputView, preSelectedItemsHandler: @escaping PreSelectedItemsHandler) {
        self.controller = controller
        self.preSelectedItemsHandler = preSelectedItemsHandler
    }
    
    public func display(_ viewModel: ResourceListViewModel) {
        var container: CLOCItemsContainer
        
        if let loadedContainer = loadedContainers[viewModel.index] {
            container = loadedContainer
        } else {
            let preSelectedItems = preSelectedItemsHandler(viewModel.index)
            container = CLOCItemsContainer(
                items: viewModel.items,
                preSelectedItems: preSelectedItems,
                selectionType: CLOCSelectableProperty(rawValue: viewModel.index)!.selectionType)
        }
        
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

        loadedContainers[viewModel.index] = container
    }
}


final class SectionSelectionPresentationAdapter {
    private let loader: ZZItemsLoader
    var presenter: LoadResourcePresenter?
    
    init(loader: ZZItemsLoader) {
        self.loader = loader
    }
    
    func selectSection(index: Int) {
        presenter?.didStartLoading()
        loader.loadItems(for: index, completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.didFinishLoading(with: items ?? [], at: index)
            case.failure(let error):
                self?.presenter?.didFinishLoading(with: error, at: index)
            }
        })
    }
}


extension SectionsPresenter: ZZSectionsControllerDelegate { }
