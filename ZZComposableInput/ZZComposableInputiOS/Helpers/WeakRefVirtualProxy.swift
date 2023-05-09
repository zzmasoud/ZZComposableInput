//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZComposableInput

public final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    public init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T:ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SectionsView where T: SectionsView {
    public func display(_ viewModel: SectionsViewModel) {
        object?.display(viewModel)
    }
    
    public func display(_ viewModel: SectionViewModel) {
        object?.display(viewModel)
    }
}
