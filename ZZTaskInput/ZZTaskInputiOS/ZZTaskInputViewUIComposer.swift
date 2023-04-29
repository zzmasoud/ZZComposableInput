//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZTaskInput

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith<T: ZZTaskInputView>(
        inputView: T,
        textParser: some TextParser,
        itemsLoader: ItemsLoader,
        sectionSelectionView: SectionedViewProtocol,
        resourceListView: ResourceListViewProtocol,
        sectionsPresenter: SectionsPresenter,
        loadResourcePresenter: LoadResourcePresenter,
        sectionsControllerDelegate: ZZSectionsControllerDelegate
    ) -> T {
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let sectionsController = inputView.sectionsController!
        sectionsController.sectionedView = sectionSelectionView
        #warning("should get sections title from presenter and be set in the composition root. but still setting a useless sections property of SectionsController which will later be used by a function call after view did load. how to fix this?")
//        sectionsController.sections = ItemsPresenter.section
        #warning("Fixed it by using a new presenter for sections. is it correct?")
        sectionsController.delegate = sectionsControllerDelegate
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        inputView.resourceListController.resourceListView = resourceListView
        presentationAdapter.presenter = loadResourcePresenter
        
        return inputView
    }
}
