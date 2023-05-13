//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

final class SelectableCellControllerTests: XCTestCase {
    
    func test_init_assignsId() {
        let id = UUID()
        let sut = SelectableCellController(id: id)
        
        XCTAssertEqual(id, sut.id)
    }
    
    func test_equatable() {
        let id = UUID()
        let sut1 = SelectableCellController(id: id)
        let sut2 = SelectableCellController(id: id)
        
        XCTAssertEqual(sut1, sut2)
    }
    
    func test_hashValue() {
        let id = UUID()
        let sut = SelectableCellController(id: id)
        
        XCTAssertEqual(id.hashValue, sut.hashValue)
    }
}
