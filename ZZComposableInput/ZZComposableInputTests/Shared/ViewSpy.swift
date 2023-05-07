//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZComposableInput

final class ViewSpy: ResourceLoadingView, ResourceListView {
    enum Message: Hashable {
        case display(isLoading: Bool)
        case display(items: [MockItem], index: Int)
    }
    
    var messages = [Message]()
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        messages.append(.display(isLoading: viewModel.isLoading))
    }
    
    func display(_ viewModel: ResourceListViewModel) {
        messages.append(.display(items: viewModel.items as! [MockItem], index: viewModel.index))
    }
}
