//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput


final class CLOCTaskInput<T: ZZTextParser>: ZZTaskInput {
    private let textParser: T
    private(set) var text: String?
    var onSent: ((ZZTaskInput.Data) -> Void)?
    
    init(textParser: T) {
        self.textParser = textParser
    }

    func set(text: String?) {
        self.text = text
    }
    
    func send() {
        guard let text = text, !text.isEmpty else { return }
        
        let parsedComponents = textParser.parse(text: text)
        onSent?(parsedComponents as! (title: String, description: String?))
    }
}

class ZZTaskInputTests: XCTestCase {
    
    func test_init_textIsNil() {
        let (sut, _) = makeSUT()
        
        XCTAssertNil(sut.text)
    }
                
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CLOCTaskInput<MockTextParser>, textParser: MockTextParser) {
        let textParser = MockTextParser()
        let sut = CLOCTaskInput(textParser: textParser)
        return (sut, textParser)
    }
    
    private func expect(_ sut: CLOCTaskInput<MockTextParser>, toCompleteWith expected: (title: String, description: String?)?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
    
    class MockTextParser: ZZTextParser {
        typealias Parsed = (title: String, description: String?)
        
        var result = Parsed("", nil)
        private(set) var separator: Character = "\n"
        private var parseTextCalles = [String]()
        
        var parseTextCount: Int { parseTextCalles.count }
        
        func parse(text: String) -> (title: String, description: String?) {
            parseTextCalles.append(text)
            return result
        }
    }
}
