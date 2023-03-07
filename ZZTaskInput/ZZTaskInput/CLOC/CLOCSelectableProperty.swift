//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

public enum CLOCSelectableProperty: Int {
    case date = 0, time, project, repeatWeekDays
    
    public var selectionType: CLOCItemSelectionType {
        switch self {
        case .date, .time, .project:
            return CLOCItemSelectionType.single
        case .repeatWeekDays:
            return CLOCItemSelectionType.multiple(max: 7)
        }
    }
}
