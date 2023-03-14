//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

enum Category: Hashable, CaseIterable {
    case fruits, animals, symbols, flags
    
    var title: String {
        switch self {
        case .fruits:
            return "🍎"
        case .animals:
            return "🦊"
        case .symbols:
            return "🔠"
        case .flags:
            return "🏴"
        }
    }
    
    var selectionType: ItemsContainerSelectionType {
        switch self {
        case .fruits:
            return .multiple(max: 2)
        case .animals:
            return .multiple(max: 3)
        case .symbols, .flags:
            return .single
        }
    }
}

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith(
        textParser: any TextParser,
        itemsLoader: ItemsLoader,
        sectionSelectionView: SectionedViewProtocol,
        preSelectedItemsHandler: @escaping PreSelectedItemsHandler
    ) -> ZZTaskInputView {
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ZZTaskInputViewComposer.self))
        let inputView = storyboard.instantiateInitialViewController() as! ZZTaskInputView
        let sectionsController = inputView.sectionsController!
        sectionsController.sectionedView = sectionSelectionView
        #warning("should get sections title from presenter and be set in the composition root. but still setting a useless sections property of SectionsController which will later be used by a function call after view did load. how to fix this?")
//        sectionsController.sections = ItemsPresenter.section
        #warning("Fixed it by using a new presenter for sections. is it correct?")
        sectionsController.delegate = SectionsPresenter(
            titles: Category.allCases.map { $0.title },
            view: WeakRefVirtualProxy(sectionsController))
        
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        
        inputView.resourceListController.resourceListView = CustomTableView(onSelection: { _ in}, onDeselection: { _ in })
        
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
