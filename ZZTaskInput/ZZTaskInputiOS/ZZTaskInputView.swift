//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIView {
    public let textField: UITextField = UITextField()
    public let segmentedControl = UISegmentedControl(items: ["date", "time", "project", "weekdaysRepeat"])
    public let selectedSectionLabel = UILabel()
    public let tableView = UITableView()
    private var inputController: DefaultTaskInput?
    
    private var tableModels = [DefaultTaskInput.SelectableItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public convenience init(inputController: DefaultTaskInput) {
        self.init()
        self.inputController = inputController
        
        setupTextField()
        setupSegmentedControl()
        setupSectionLabel()
        setupTableView()
    }

    private func setupTextField() {
        self.addSubview(textField)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = -1
        segmentedControl.addTarget(self, action: #selector(selectSection), for: .valueChanged)
    }
    
    private func setupSectionLabel() {
        selectedSectionLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
    }
    
    @objc private func selectSection() {
        let index = segmentedControl.selectedSegmentIndex
        selectedSectionLabel.isHidden = true
        inputController?.select(section: CLOCSelectableProperty(rawValue: index)!, withPreselectedItems: nil, completion: { [weak self] result in
            switch result {
            case .success(let container):
                self?.tableModels = container.items ?? []
                
            case .failure:
                break
            }
            self?.selectedSectionLabel.isHidden = false
        })
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
        return tableModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableModels[indexPath.row]
        let cell =  UITableViewCell()
        cell.textLabel?.text = model
        return cell
    }
}

