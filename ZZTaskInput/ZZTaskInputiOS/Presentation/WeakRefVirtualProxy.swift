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
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}
