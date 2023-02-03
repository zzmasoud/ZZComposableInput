//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class CLOCTaskInputTests: XCTestCase {
    
    func test_init_textIsNil() {
        let (sut, _) = makeSUT()
        
        XCTAssertNil(sut.text)
    }
                
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, textParser: MockTextParser) {
        let textParser = MockTextParser()
        let sut = CLOCTaskInput(textParser: textParser, itemLoader: ItemLoaderSpy())
        return (sut, textParser)
    }
    
    private func expect(_ sut: CLOCTaskInput<MockTextParser, ItemLoaderSpy>, toCompleteWith expected: (title: String, description: String?)?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting for completion...")
        exp.isInverted = expected == nil
        
        sut.onSent = { (received) in
            if let expected = expected {
                XCTAssertEqual(received.title, expected.title, "expected to get [title] \(expected.title) but got \(received.title)", file: file, line: line)
                XCTAssertEqual(received.description, expected.description, "expected to get [description] \(expected.description ?? "") but got \(received.description ?? "")", file: file, line: line)
            } else {
                XCTFail("expected to not get completion", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
