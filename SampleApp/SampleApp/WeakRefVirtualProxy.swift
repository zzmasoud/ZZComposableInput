//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T:ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SectionsView where T: SectionsView {
    func display(_ viewModel: SectionsViewModel) {
        object?.display(viewModel)
    }
    
    func display(_ viewModel: SectionViewModel) {
        object?.display(viewModel)
    }
}