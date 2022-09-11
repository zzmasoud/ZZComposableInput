//
//  ZZNewTaskView_VM.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/10/22.
//

import Foundation
//import UIKit.UIColor

struct Data: ZZHorizontalSelectorViewPresentable {
    var isSelected: Bool
    var color: CGColor
    var title: String
}

public protocol ZZNewTaskView_VMP {
    var isRepeatOptionHidden: Bool { get }
    func didTapSendButton()
    var currentTitle: String? { get }
    var isSendButtonEnabled: Bool { get }
    func textValueChanged(to text: String?)
    var selectorViewViewModel: ZZHorizontalSelectorView_VMP { get }
    func didSelectButton(at index: Int)
    func setView(delegate: AnyObject)
}
