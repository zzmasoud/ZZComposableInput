//
//  ZZNewTaskView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/9/22.
//

import Foundation
import UIKit

public protocol ZZNewTask_VD: AnyObject {
    func set(text: String)
    func dismiss()
    func toggleSendButton(isEnabled: Bool)
    func updateButton(current: Bool, selected: Bool, at index: Int)
    func updateUI()
    func fillUI()
}

open class ZZNewTaskView: UIView {
    
    // test purpose only
    public init() {}
    
    // IBOutlets
    let selectorView = ZZHorizontalSelectorView()
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var selectorTitleLabel: UILabel!
    
    // IBAction
    @IBAction func selectButton(_ sender: UIButton) {
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
//        config(button: UIButton(), selected: selected, current: current)
    }
    
    public func updateUI() {
        selectorTitleLabel.text = viewModel.currentTitle ?? "-"
        selectorView.viewModel = viewModel.selectorViewViewModel
    }
    
    public func fillUI() {
        
    }    
}
