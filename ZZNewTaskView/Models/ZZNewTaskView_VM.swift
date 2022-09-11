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
    var color: CGColor = .clear
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

open class ZZNewTaskView_VM: NSObject {
    
    enum Index: Int {
        case none = -1, date = 0, time, project, tags, repeatedDays
        
        var title: String? {
            switch self {
            case .date:
                return "date"
            case .time:
                return "estimated time"
            case .tags:
                return "tags"
            case .project:
                return "project"
            case .repeatedDays:
                return "Repeat"
            default:
                return nil
            }
        }
    }
    
    private var currentIndex: Index = .none
    
}
