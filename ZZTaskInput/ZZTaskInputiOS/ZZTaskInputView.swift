//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
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

final public class ZZTaskInputView: UIView {
    private(set) public var segmentedControl: UISegmentedControl?
    public let textField: UITextField = UITextField()
    public let tableView = UITableView()
    
    var sectionsController: ZZSectionsController?
    var model: DefaultTaskInput.ItemType?
    var cellControllers = [ZZSelectableCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    public var selectedSectionLabel: UILabel? {
        sectionsController?.label
    }
    
    convenience init(sectionsController: ZZSectionsController) {
        self.init()
        self.sectionsController = sectionsController
        setupTextField()
        setupSegmentedControl()
        setupTableView()
    }
    
    private func setupTextField() {
        self.addSubview(textField)
    }
    
    private func setupSegmentedControl() {
        segmentedControl = sectionsController?.view
    }
    
    private func setupTableView() {
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.window != nil {
            self.textField.becomeFirstResponder()
        }
    }
}

extension ZZTaskInputView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view()
    }
}

extension ZZTaskInputView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model?.select(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        model?.unselect(at: indexPath.row)
    }
}
