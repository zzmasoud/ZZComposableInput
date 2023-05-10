//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import ZZComposableInput

enum MockSection: Int, CaseIterable {
    case a=1, b, c, d
    
    var selectionType: ItemsContainerSelectionType {
        switch self {
        case .a: return .single
        default: return .multiple(max: self.rawValue)
        }
    }
    
    var title: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        case .c: return "C"
        case .d: return "D"
        }
    }
}
