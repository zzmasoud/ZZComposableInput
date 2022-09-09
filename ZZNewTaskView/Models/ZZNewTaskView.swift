//
//  ZZNewTaskView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/9/22.
//

import Foundation

public protocol ZZNewTask_VD: AnyObject {
    func set(text: String)
    func dismiss()
    func toggleSendButton(isEnabled: Bool)
    func updateButton(current: Bool, selected: Bool, at index: Int)
    func updateUI()
    func fillUI()
}

protocol UIView {}
class UIButton {}
protocol ZZHorizontalSelectorView {}

open class ZZNewTaskView: UIView {
    
    // IBOutlets
    var selectorView: ZZHorizontalSelectorView!
    
    // IBAction
    
    static public var _configs: ZZNewTaskViewConfigs!
    public var configs: ZZNewTaskViewConfigs { return Self._configs }
    
    public var doneCompletion: (()->Void)?
    public var didTapAddInSelectorView: (()->Void)?
    
    private func setup() {
        // Load from Nib and assign delegate of textView
        styleUI()
    }
    
    private func styleUI() {
        // style UI from the configuration: `config`
    }
    
    private func config(button: UIButton, selected: Bool, current: Bool) {
        if selected {
//            button.tintColor = configs.buttonsFilledTintColor
//            button.backgroundColor = configs.buttonsFilledBGColor
        } else if current {
//            button.tintColor = .white
//            button.backgroundColor = configs.tintColor
        } else {
//            button.tintColor = configs.buttonsDefaultTintColor
//            button.backgroundColor = configs.buttonsDefaultBGColor
        }
    }
}

extension ZZNewTaskView: ZZNewTask_VD {
    public func set(text: String) {
        
    }
    
    public func dismiss() {
        doneCompletion?()
    }
    
    public func toggleSendButton(isEnabled: Bool) {
        
    }
    
    public func updateButton(current: Bool, selected: Bool, at index: Int) {
        config(button: UIButton(), selected: selected, current: current)
    }
    
    public func updateUI() {
        
    }
    
    public func fillUI() {
        
    }
    
    
}
