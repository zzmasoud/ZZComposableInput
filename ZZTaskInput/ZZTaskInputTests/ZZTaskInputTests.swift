//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    var onSent: ZZTaskInput.SendCompletion { get }
    func send()
}

class CLOCTaskInput {
    private(set) var text: String?
    private(set) var onSent: ZZTaskInput.SendCompletion
    
    init(onSent: @escaping ZZTaskInput.SendCompletion) {
        self.onSent = onSent
    }
    
    func set(text: String?) {
        self.text = text
    }
    
    func send() {
        guard let _ = text else { return }
        onSent(("", nil))
    }
}

class ZZTaskInputTests: XCTestCase {
    
    func test_init_textIsEmpty() {
        let sut = CLOCTaskInput(onSent: {_ in })
            
        XCTAssertNil(sut.text)
    }
    
    func test_send_doesNotDeliverIfTextIsEmpty() {
        let exp = expectation(description: "waiting for completion...")
        exp.isInverted = true

        let sut = CLOCTaskInput(
            onSent: { _ in
                XCTFail("expected to not get completion")
                exp.fulfill()
            }
        )
        
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_send_deliversDataIfTextIsNotEmpty() {
        let exp = expectation(description: "waiting for completion...")

        let sut = CLOCTaskInput(
            onSent: { _ in
                exp.fulfill()
            }
        )
        sut.set(text: "Hello World!")
        
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
}
