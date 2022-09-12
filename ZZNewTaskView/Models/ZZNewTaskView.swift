//
//  ZZNewTaskView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/9/22.
//

import Foundation
import AppKit

protocol UIView {}
class UIButton {}

public protocol ZZNewTask_VD: AnyObject {
    func set(text: String)
    func dismiss()
    func toggleSendButton(isEnabled: Bool)
    func updateButton(current: Bool, selected: Bool, at index: Int)
    func updateUI()
    func fillUI()
}

open class ZZNewTaskView: UIView {
    
    // IBOutlets
    var selectorView: ZZHorizontalSelectorView!
    @IBOutlet private weak var textView: NSTextView!
    @IBOutlet private weak var sendButton: NSButton!
    @IBOutlet private weak var buttonsStackView: NSStackView!
    @IBOutlet private weak var selectorTitleLabel: NSTextField!
    
    // IBAction
    private func buttonsAction(_ sender: NSButton) {
        viewModel.didSelectButton(at: sender.tag)
    }
    
    public var doneCompletion: (()->Void)?
    public var didTapAddInSelectorView: (()->Void)?
    
    public var viewModel: ZZNewTaskView_VMP! {
        didSet {
            viewModel.setView(delegate: self)
        }
    }
    
    private func setup() {
        // Load from Nib and assign delegate of textView
        
        selectorView.addNewItem = {
            self.didTapAddInSelectorView?()
        }
    }
    private func config(button: UIButton, selected: Bool, current: Bool) {
        // change color of selected and deselected items
    }
}

extension ZZNewTaskView: ZZNewTask_VD {
    public func set(text: String) {
        // when it's editing a task, manually fills the textView's text.
    }
    
    public func dismiss() {
        doneCompletion?()
    }
    
    public func toggleSendButton(isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
    }
    
    public func updateButton(current: Bool, selected: Bool, at index: Int) {
        config(button: UIButton(), selected: selected, current: current)
    }
    
    public func updateUI() {
        selectorTitleLabel.stringValue = viewModel.currentTitle
        selectorView.viewModel = viewModel.selectorViewViewModel
        
    }
    
    public func fillUI() {
        
    }
    
    
}
