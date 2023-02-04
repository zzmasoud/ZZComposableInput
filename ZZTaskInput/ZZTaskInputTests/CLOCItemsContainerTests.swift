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
}


