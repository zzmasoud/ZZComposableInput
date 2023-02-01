//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    func send(completion: SendCompletion)
}

class CLOCTaskInput {
    private(set) var text: String?
    
    func set(text: String?) {
        
    }
}

class ZZTaskInputTests: XCTestCase {
    
    func test_init_textIsEmpty() {
        let sut = CLOCTaskInput()
        
        sut.set(text: nil)
        
        XCTAssertNil(sut.text)
    }
}
