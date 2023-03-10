//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIViewController {
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
    public var onCompletion: (() -> Void)?
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    
    convenience init(sectionsController: ZZSectionsController) {
        self.init()
        self.sectionsController = sectionsController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupSegmentedControl()
        setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    private func setupTextField() {
        self.view.addSubview(textField)
    }
    
    private func setupSegmentedControl() {
        segmentedControl = sectionsController?.view
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.register(ZZSelectableCell.self, forCellReuseIdentifier: ZZSelectableCell.id)
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
        onSelection?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselection?(indexPath.row)
    }
}
