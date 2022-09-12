//
//  ZZHorizontalSelectorView_VM.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/10/22.
//

import Foundation

public protocol ZZHorizontalSelectorView_VMP {
    typealias T = ZZHorizontalSelectorViewPresentable
    
    func add(item: T)
    var canAddNewItem: Bool { get }
    var didNotSelectAny: Bool { get }
    var selectedIndexes: [Int] { get }
    var selectedItems: [T]? { get }
    func didDeselect(index: Int)
    func didSelect(index: Int)
    var multipleSelection: Bool { get }
    func item(for index: Int) -> T
    var itemsCount: Int { get }
    func setView(delegate: AnyObject)
}

public class ZZHorizontalSelectorView_VM: NSObject {
    public typealias T = ZZHorizontalSelectorViewPresentable
    
    private weak var view: ZZHorizontalSelector_VD? {
        didSet {
            view?.fillUI()
        }
    }
    private let selectionLimit: Int
    private var items: [T]
    
    // to handle collection view selection
    public var selectedIndexes: [Int]
    public var canAddNewItem: Bool
    
    public init(items: [T], selectionLimit: Int, defaultSelections: [Int] = [], canAddNewItem: Bool = true) {
        self.items = items
        self.selectionLimit = selectionLimit
        self.selectedIndexes = defaultSelections
        self.canAddNewItem = canAddNewItem
    }
}

extension ZZHorizontalSelectorView_VM: ZZHorizontalSelectorView_VMP {
    public func add(item: T) {
        self.items.append(item)
        if selectionLimit > 1 {
            selectedIndexes.append(items.count - 1)
        } else {
            selectedIndexes = [items.count - 1]
        }
        view?.fillUI()
    }
    
    public var didNotSelectAny: Bool {
        return selectedIndexes.isEmpty
    }
    
    public var selectedItems: [ZZHorizontalSelectorViewPresentable]? {
        return self.selectedIndexes.map({ return items[$0] })
    }
    
    public func didDeselect(index: Int) {
        selectedIndexes = selectedIndexes.filter({$0 != index })
    }
    
    public func didSelect(index: Int) {
        selectedIndexes.append(index)
    }
    
    public var multipleSelection: Bool {
        return selectionLimit > 1
    }
    
    public func item(for index: Int) -> ZZHorizontalSelectorViewPresentable {
        return items[index]
    }
    
    public var itemsCount: Int {
        return items.count
    }
    
    public func setView(delegate: AnyObject) {
        self.view = delegate as? ZZHorizontalSelector_VD
    }
}
