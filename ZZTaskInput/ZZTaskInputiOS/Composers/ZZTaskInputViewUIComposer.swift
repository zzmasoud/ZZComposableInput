//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation
import ZZTaskInput

public final class ZZTaskInputViewComposer {
    public typealias ParsedText = (title: String, description: String?)
    public typealias PreSelectedItemsHandler = (Int) -> ([NEED_TO_BE_GENERIC]?)
    private init() {}
    
    public static func composedWith(
        textParser: CLOCTextParser,
        itemsLoader: ZZItemsLoader,
        preSelectedItemsHandler: PreSelectedItemsHandler?
    ) -> ZZTaskInputView {
            let sectionsController = ZZSectionsController(
                loader: itemsLoader,
                sections: ["date", "time", "project", "weekdaysRepeat"],
                indexMapper: { index in
                    return CLOCSelectableProperty(rawValue: index)!
                })
        
            let inputView = ZZTaskInputView(sectionsController: sectionsController)
            inputView.onCompletion = { [weak inputView] in
                guard let text = inputView?.text else { return }
                let (title, description) = textParser.parse(text: text)
            }
            
            sectionsController.onLoad = { [weak inputView] (index, result) in
                guard let inputView = inputView else { return }
                if let items = try? result.get() {
                    let preSelectedItems = preSelectedItemsHandler?(index)
                    let container = CLOCItemsContainer(
                        items: items,
                        preSelectedItems: preSelectedItems,
                        selectionType: CLOCSelectableProperty(rawValue: index)!.selectionType)
                    
                    inputView.cellControllers = adaptContainerItemsToCellControllers(
                        forwardingTo: inputView,
                        container: container)
                    
                    inputView.onSelection = { [weak container] index in
                        container?.select(at: index)
                    }
                    
                    inputView.onDeselection = { [weak container] index in
                        container?.unselect(at: index)
                    }
                    
                } else {
                    inputView.cellControllers = []
                }
            }

            return inputView
        }
        
    private static func adaptContainerItemsToCellControllers(forwardingTo controller: ZZTaskInputView, container: CLOCItemsContainer) -> [ZZSelectableCellController] {
        (container.items ?? []).map { item in
            return ZZSelectableCellController(text: item.title, isSelected: {
                container.selectedItems?.contains(item) ?? false
            })
        }
    }
}

