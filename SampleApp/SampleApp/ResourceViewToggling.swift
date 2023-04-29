//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct ResourceViewTogglingViewModel {
    public var isHidden: Bool
}

public protocol ResourceViewToggling {
    func display(_ viewModel: ResourceViewTogglingViewModel)
}

public final class ResourceViewTogglingPresenter {
    private let view: ResourceViewToggling
    
    public init(view: ResourceViewToggling) {
        self.view = view
    }
    
    public func viewDidLoad() {
        view.display(ResourceViewTogglingViewModel(
            isHidden: true
        ))
    }
    
    public func selectSection() {
        view.display(ResourceViewTogglingViewModel(
            isHidden: false
        ))
    }
}
