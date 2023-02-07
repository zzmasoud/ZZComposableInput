//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIView {
    private(set) public var segmentedControl: UISegmentedControl?
    public let textField: UITextField = UITextField()
    public let selectedSectionLabel = UILabel()
    public let tableView = UITableView()
    private var inputController: DefaultTaskInput?
    private var sectionsController: ZZSectionsController?
    
    private var model: DefaultTaskInput.ItemType? {
        didSet {
            tableView.reloadData()
        }
    }
    private var cellControllers: [IndexPath: ZZSelectableCellController] = [:]
    
    public convenience init(inputController: DefaultTaskInput) {
        self.init()
        self.inputController = inputController
        self.sectionsController = ZZSectionsController(
            loader: inputController,
            sections: ["date", "time", "project", "weekdaysRepeat"],
            indexMapper: { index in
                return CLOCSelectableProperty(rawValue: index)!
            })
        setupTextField()
        setupSegmentedControl()
        setupSectionLabel()
        setupTableView()
    }
    
    private func setupTextField() {
        self.addSubview(textField)
    }
    
    private func setupSectionLabel() {
        selectedSectionLabel.isHidden = true
    }
    
    private func setupSegmentedControl() {
        segmentedControl = sectionsController?.view
        sectionsController?.onLoading = { [weak self] in
            self?.selectedSectionLabel.isHidden = true
        }
        sectionsController?.onLoad = { [weak self] result in
            switch result {
            case .success(let container):
                self?.model = container
                
            case .failure:
                break
            }
            self?.selectedSectionLabel.isHidden = false
        }
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
        return (model?.items ?? []).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = ZZSelectableCellController()
        cellControllers[indexPath] = cellController
        let item = model!.items![indexPath.row]
        let isSelected = model?.selectedItems?.contains(item) ?? false
        return cellController.view(text: item, isSelected: isSelected)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(at: indexPath)
    }
    
    private func removeCellController(at indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}

extension ZZTaskInputView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(true, animated: false)
        model?.select(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        model?.unselect(at: indexPath.row)
        cell?.setSelected(false, animated: false)
    }
}
