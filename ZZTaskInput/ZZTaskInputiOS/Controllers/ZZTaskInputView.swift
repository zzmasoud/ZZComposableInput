//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIViewController {
    @IBOutlet private(set) public var textField: UITextField!
    @IBOutlet private(set) public var tableView: UITableView!
    @IBOutlet private(set) var sectionsController: ZZSectionsController!
    
    public var segmentedControl: UISegmentedControl {
        return sectionsController.segmentedControl
    }
    
    var cellControllers = [ZZSelectableCellController]() {
        didSet {
            tableView.allowsMultipleSelection = true
            tableView.reloadData()
        }
    }
    
    public var selectedSectionLabel: UILabel? { sectionsController?.label }
    public var text: String? { textField.text }    
    public var onCompletion: (() -> Void)?
    public var onSelection: ((Int) -> Void)?
    public var onDeselection: ((Int) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #warning("how to achive this? where should I set default UI config? setting this to hidden in the storyboard is somehow ugly because it got disappear from the interface builder")
        sectionsController.label.isHidden = true
        sectionsController.setSections()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
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
        return cellControllers[indexPath.row].view(for: tableView, at: indexPath)
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
