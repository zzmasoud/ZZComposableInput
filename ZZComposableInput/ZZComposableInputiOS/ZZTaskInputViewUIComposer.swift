//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import UIKit
import ZZComposableInput

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith<T: ZZComposableInput>(
        inputView: T,
        itemsLoader: some ItemsLoader,
        sectionSelectionView: SectionedViewProtocol,
        resourceListView: ResourceListViewProtocol,
        sectionsPresenter: SectionsPresenter,
        loadResourcePresenter: LoadResourcePresenter
    ) -> T {
        let presentationAdapter = LoadResourcePresentationAdapter(
            loader: itemsLoader)
 
        let sectionsController = inputView.sectionsController!
        sectionsController.sectionedView = sectionSelectionView
        let sectionDelegateAdapter = SectionsControllerDelegateAdapter(sectionsPresenter: sectionsPresenter, sectionLoadCallback: presentationAdapter.selectSection(index:))
        sectionsController.delegate = sectionDelegateAdapter
        inputView.resourceListController.resourceListView = resourceListView
        presentationAdapter.presenter = loadResourcePresenter
        
        return inputView
    }
}
