//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput

public enum Category: Int, CaseIterable {
    case fruits = 0, animals, symbols, flags
    
    public var title: String {
        switch self {
        case .fruits:
            return "🍎"
        case .animals:
            return "🦊"
        case .symbols:
            return "🔠"
        case .flags:
            return "🏴"
        }
    }
    
    public var selectionType: ItemsContainerSelectionType {
        switch self {
        case .fruits:
            return .multiple(max: 4)
        case .animals:
            return .multiple(max: 7)
        case .symbols, .flags:
            return .single
        }
    }
}
