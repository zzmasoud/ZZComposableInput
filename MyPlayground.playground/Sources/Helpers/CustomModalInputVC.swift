//
//  CustomModalInputVC.swift
//  ZZNewTaskViewTests
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import Foundation

public class UIViewController {}
public class CustomModalInputVC: UIViewController {
    public static let id = "CustomModalInputVC"
    
    public enum Child {
        case date, time, project, timeRecord
        var id: String {
            switch self {
            case .date:
                return "dateInput"
            case .time:
                return "timeInput"
            case .project:
                return "newProjectInput"
            case .timeRecord:
                return "timeRecordInput"
            }
        }
    }
    
    public static func setup(with child: Child, completion: @escaping ((Any)->Void)) -> UIViewController {
        return UIViewController()
    }
}
