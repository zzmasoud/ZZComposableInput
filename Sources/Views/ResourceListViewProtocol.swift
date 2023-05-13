//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ResourceListViewProtocol: AnyObject {
    associatedtype View
    associatedtype CellController: SelectableCellController
    
    var view: View { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [CellController])
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
    func deselect(at: Int)
}
