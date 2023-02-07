//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZTaskInput

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith(inputController: DefaultTaskInput) -> ZZTaskInputView {
        let sectionsController = ZZSectionsController(
            loader: inputController,
            sections: ["date", "time", "project", "weekdaysRepeat"],
            indexMapper: { index in
                return CLOCSelectableProperty(rawValue: index)!
            })
        let inputView = ZZTaskInputView(sectionsController: sectionsController)
        sectionsController.onLoad = { [weak inputView] result in
            guard let inputView = inputView else { return }
            
            switch result {
            case .success(let container):
                inputView.model = container
                inputView.cellControllers = adaptContainerItemsToCellControllers(forwardingTo: inputView, container: container)
                
            case .failure:
                break
            }
        }
        return inputView
    }
    
    private static func adaptContainerItemsToCellControllers(forwardingTo controller: ZZTaskInputView, container: CLOCItemsContainer) -> [ZZSelectableCellController] {
        (container.items ?? []).map { item in
            return ZZSelectableCellController(text: item, isSelected: {
                container.selectedItems?.contains(item) ?? false
            })
        }
    }
}

