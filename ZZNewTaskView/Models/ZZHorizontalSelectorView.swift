//
//  ZZHorizontalSelectorView.swift
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
