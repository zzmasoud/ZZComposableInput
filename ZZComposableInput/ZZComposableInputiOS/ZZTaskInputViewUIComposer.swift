//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import ZZComposableInput

public protocol ZZComposableInput: ZZComposableInputDataSource, ZZComposableInputDelegate {}

public protocol ZZComposableInputDataSource: AnyObject {
    var sectionsController: SectionsControllerProtocol! { get }
    var resourceListController: ResourceListControllerProtocol! { get }
}

public protocol ZZComposableInputDelegate: AnyObject {
    var onSelection: ((Int) -> Void)? { get set }
    var onDeselection: ((Int) -> Void)? { get set }
}

final class ZZTaskInputViewComposer {
    private init() {}
    
    static func composedWith<T: ZZComposableInput>(
        inputView: T,
        itemsLoader: some ItemsLoader,
        sectionsPresenter: SectionsPresenter,
        loadResourcePresenter: LoadResourcePresenter
    ) -> T {
        let presentationAdapter = LoadResourcePresentationAdapter(
            loader: itemsLoader)
 
        let sectionDelegateAdapter = SectionsControllerDelegateAdapter(sectionsPresenter: sectionsPresenter, sectionLoadCallback: presentationAdapter.selectSection(index:))
        inputView.sectionsController!.delegate = sectionDelegateAdapter
        presentationAdapter.presenter = loadResourcePresenter
        
        return inputView
    }
}
