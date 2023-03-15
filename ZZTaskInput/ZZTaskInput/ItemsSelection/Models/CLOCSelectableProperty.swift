//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

public enum CLOCSelectableProperty: Int {
    case date = 0, time, project, repeatWeekDays
    
    public var selectionType: ItemsContainerSelectionType {
        switch self {
        case .date, .time, .project:
            return ItemsContainerSelectionType.single
        case .repeatWeekDays:
            return ItemsContainerSelectionType.multiple(max: 7)
        }
    }
}
