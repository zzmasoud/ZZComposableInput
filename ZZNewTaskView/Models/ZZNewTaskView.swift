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

}
