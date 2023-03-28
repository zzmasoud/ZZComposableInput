//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith(
        inputView: ZZTaskInputView,
        textParser: any TextParser,
        itemsLoader: ItemsLoader,
        sectionSelectionView: SectionedViewProtocol,
        resourceListView: ResourceListViewProtocol,
        sectionsPresenter: SectionsPresenter,
        loadResourcePresenter: LoadResourcePresenter
    ) -> ZZTaskInputView {
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let sectionsController = inputView.sectionsController!
        sectionsController.sectionedView = sectionSelectionView
        #warning("should get sections title from presenter and be set in the composition root. but still setting a useless sections property of SectionsController which will later be used by a function call after view did load. how to fix this?")
//        sectionsController.sections = ItemsPresenter.section
        #warning("Fixed it by using a new presenter for sections. is it correct?")
        sectionsController.delegate = sectionsPresenter
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        inputView.resourceListController.resourceListView = resourceListView
        presentationAdapter.presenter = loadResourcePresenter
        
        inputView.onCompletion = { [weak inputView] in
            guard let text = inputView?.text else { return }
            let _ = textParser.parse(text: text)
        }
        
        return inputView
    }
}
