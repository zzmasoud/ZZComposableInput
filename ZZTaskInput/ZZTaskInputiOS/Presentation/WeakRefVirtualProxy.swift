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

extension WeakRefVirtualProxy: ItemsLoadingView where T:ItemsLoadingView {
    func display(_ viewModel: ItemsLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SectionsView where T: SectionsView {
    func disply(_ viewModel: SectionsViewModel) {
        object?.disply(viewModel)
    }
    
    func display(_ viewModel: SectionViewModel) {
        object?.display(viewModel)
    }
}
