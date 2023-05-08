//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZComposableInput

final class ViewSpy: ResourceLoadingView, ResourceListView, SectionsView {
    enum Message: Hashable {
        case display(isLoading: Bool)
        case display(items: [MockItem], index: Int)
        case display(sections: [String], index: Int)
        case display(section: String)
    }
    
    var messages = [Message]()
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        messages.append(.display(isLoading: viewModel.isLoading))
    }
    
    func display(_ viewModel: ResourceListViewModel) {
        messages.append(.display(items: viewModel.items as! [MockItem], index: viewModel.index))
    }
    
    func display(_ viewModel: SectionsViewModel) {
        messages.append(.display(sections: viewModel.titles, index: viewModel.selectedIndex))
    }
    
    func display(_ viewModel: SectionViewModel) {
        messages.append(.display(section: viewModel.title))
    }
}
