//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

final public class ZZTaskInputView: UIView {
    public let textField: UITextField = UITextField()
    public let segmentedControl = UISegmentedControl(items: ["date", "time", "project", "weekdaysRepeat"])
    public let selectedSectionLabel = UILabel()
    private var inputController: DefaultTaskInput?
    
    public convenience init(inputController: DefaultTaskInput) {
        self.init()
        self.inputController = inputController
        
        setupTextField()
        setupSegmentedControl()
        setupSectionLabel()
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
    
    @objc private func selectSection() {
        let index = segmentedControl.selectedSegmentIndex
        selectedSectionLabel.isHidden = true
        inputController?.select(section: CLOCSelectableProperty(rawValue: index)!, withPreselectedItems: nil, completion: { [weak self] _ in
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

