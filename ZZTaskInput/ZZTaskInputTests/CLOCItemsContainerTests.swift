//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class CLOCItemsContainerTests: XCTestCase {
    
    func test_init_selectedItemsIsEmpty() {
        let items = ["a"]
        let sut = CLOCItemsContainer(items: items)
        
        XCTAssertNil(sut.selectedItems)
    }
    
    func test_initWithPreSelectedIndexes_selectedItemsIsAssigned() {
        let items = ["a", "b", "c"]
        let preSelectedIndex = 1
        
        let sut = CLOCItemsContainer(items: items, preSelectedIndexes: [preSelectedIndex])
        
        XCTAssertEqual(sut.selectedItems, [items[preSelectedIndex]])
    }
}


