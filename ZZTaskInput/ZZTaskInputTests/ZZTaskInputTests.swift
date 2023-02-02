//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

protocol ZZTaskInput {
    typealias Data = (title: String, description: String?)
    typealias SendCompletion = (Data) -> Void
    
    var onSent: ZZTaskInput.SendCompletion? { get }
    func send()
}

final class CLOCTaskInput<T: CLOCTextParser>: ZZTaskInput {
    private let textParser: T
    private(set) var text: String?
    var onSent: ZZTaskInput.SendCompletion?
    
    init(textParser: T) {
        self.textParser = textParser
    }
    
    func set(text: String?) {
        self.text = text
    }
    
    func send() {
        guard let text = text, !text.isEmpty else { return }
        
        let data = textParser.parse(text: text)
        onSent?(data)
    }
}

class ZZTaskInputTests: XCTestCase {
    
    func test_init_textIsNil() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.text)
    }
    
    func test_send_doesNotDeliverIfTextIsNilOrEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .none) {
            sut.send()
        }
        
        sut.set(text: "")
        expect(sut, toCompleteWith: .none) {
            sut.send()
        }
    }
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CLOCTaskInput<CLOCTextParser> {
        let textParser = CLOCTextParser()
        let sut = CLOCTaskInput(textParser: textParser)
        return sut
    }
    
    private func expect(_ sut: CLOCTaskInput<CLOCTextParser>, toCompleteWith expected: (title: String, description: String?)?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
