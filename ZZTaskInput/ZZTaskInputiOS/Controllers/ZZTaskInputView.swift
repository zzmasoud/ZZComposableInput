//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIView {
    private(set) public var segmentedControl: UISegmentedControl?
    private (set) public var textField: UITextField = UITextField()
    private(set) public var tableView = UITableView()
    
    
    var sectionsController: ZZSectionsController?
    var cellControllers = [ZZSelectableCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var selectedSectionLabel: UILabel? { sectionsController?.label }
    public var text: String? { textField.text }
    #warning("this is a bad dependancy!")
    public var preSelectedItems: [NEED_TO_BE_GENERIC]?
    
    public var onCompletion: (() -> Void)?
    
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
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}
