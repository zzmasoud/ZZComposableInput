//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ResourceListControllerProtocol: AnyObject, ResourceLoadingView {
    associatedtype ResourceListView: ResourceListViewProtocol

    var delegate: ResourceListControllerDelegate? { get set }
    var resourceListView: ResourceListView? { get }
    func set(cellControllers: [ResourceListView.CellController])
}
