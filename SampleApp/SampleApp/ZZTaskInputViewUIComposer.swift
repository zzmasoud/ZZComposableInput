//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

public enum Category: Int, CaseIterable {
    case fruits = 0, animals, symbols, flags
    
    public var title: String {
        switch self {
        case .fruits:
            return "🍎"
        case .animals:
            return "🦊"
        case .symbols:
            return "🔠"
        case .flags:
            return "🏴"
        }
    }
    
    public var selectionType: ItemsContainerSelectionType {
        switch self {
        case .fruits:
            return .multiple(max: 4)
        case .animals:
            return .multiple(max: 7)
        case .symbols, .flags:
            return .single
        }
    }
}

public final class ZZTaskInputViewComposer {
    private init() {}
    
    public static func composedWith(
        inputView: ZZTaskInputView,
        textParser: any TextParser,
        itemsLoader: ItemsLoader,
        sectionSelectionView: SectionedViewProtocol,
        sectionsPresenter: SectionsPresenter,
        loadResourcePresenter: LoadResourcePresenter
    ) -> ZZTaskInputView {
        let presentationAdapter = SectionSelectionPresentationAdapter(
            loader: itemsLoader)
 
        let sectionsController = inputView.sectionsController!
        sectionsController.sectionedView = sectionSelectionView
        #warning("should get sections title from presenter and be set in the composition root. but still setting a useless sections property of SectionsController which will later be used by a function call after view did load. how to fix this?")
//        sectionsController.sections = ItemsPresenter.section
        #warning("Fixed it by using a new presenter for sections. is it correct?")
        sectionsController.delegate = sectionsPresenter
        sectionsController.loadSection = presentationAdapter.selectSection(index:)
        inputView.resourceListController.resourceListView = CustomTableView()
        presentationAdapter.presenter = loadResourcePresenter
        
        inputView.onCompletion = { [weak inputView] in
            guard let text = inputView?.text else { return }
            let _ = textParser.parse(text: text)
        }
        
        return inputView
    }
}

private final class CustomTableView: NSObject, ResourceListViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = UITableView()
    public var onSelection: ((Int) -> Void) = { _ in }
    public var onDeselection: ((Int) -> Void) = { _ in }
    
    public var view: UIView { return tableView }
    
    private var cellControllers: [ZZSelectableCellController] = []

    public func reloadData(with cellControllers: [ZZSelectableCellController]) {
        self.cellControllers = cellControllers
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
        tableView.reloadData()
    }
    
    public func allowMultipleSelection(_ isOn: Bool) {
        tableView.allowsMultipleSelection = isOn
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        let cell = controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.setSelected(controller.isSelected(), animated: false)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection(indexPath.row)
    }
}
