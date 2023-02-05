//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public struct CLOCTaskModel {
    public typealias Section = CLOCSelectableProperty
    public typealias Item = String
    public typealias SelectedItems = [Section : [Item]]
    
    private(set) public var title: String
    private(set) public var description: String?
    private(set) public var selectedItems: SelectedItems
    
    init(title: String, description: String?, selectedItems: SelectedItems = [:]) {
        self.title = title
        self.description = description
        self.selectedItems = selectedItems
    }
}
