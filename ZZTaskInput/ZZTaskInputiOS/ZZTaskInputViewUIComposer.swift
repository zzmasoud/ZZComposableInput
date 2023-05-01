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
        sectionsController.delegate = sectionsControllerDelegate
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        inputView.resourceListController.resourceListView = resourceListView
        presentationAdapter.presenter = loadResourcePresenter
        
        return inputView
    }
}
