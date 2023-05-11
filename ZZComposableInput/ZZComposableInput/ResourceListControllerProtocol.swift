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
    func reload()
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
    func deselect(at: Int)
}

public protocol ResourceListControllerDelegate {
    func didSelectResource(at: Int)
    func didDeselectResource(at: Int)
}

public protocol ResourceListControllerProtocol: AnyObject, ResourceLoadingView {
    associatedtype ResourceListView: ResourceListViewProtocol

    var delegate: ResourceListControllerDelegate? { get set }
    var resourceListView: ResourceListView? { get }
    func set(cellControllers: [ResourceListView.CellController])
}


open class SelectableCellController {
    public let id: AnyHashable
    public var isSelected: (() -> (Bool))?
    
    public init(id: AnyHashable) {
        self.id = id
    }
}

extension SelectableCellController: Equatable {
    public static func == (lhs: SelectableCellController, rhs: SelectableCellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension SelectableCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
