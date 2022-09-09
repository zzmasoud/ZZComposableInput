//
//  ZZNewTaskView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/9/22.
//

import Foundation

public protocol ZZNewTask_VD: class {
    func set(text: String)
    func dismiss()
    func toggleSendButton(isEnabled: Bool)
    func updateButton(current: Bool, selected: Bool, at index: Int)
    func updateUI()
    func fillUI()
}
