//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import Foundation

public protocol ZZComposableInput: AnyObject {
    var sectionsController: SectionsControllerProtocol! { get }
}

public final class ZZComposableInputComposer {
    private init() {}
    
    public static func composedWith<T: ZZComposableInput>(
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
