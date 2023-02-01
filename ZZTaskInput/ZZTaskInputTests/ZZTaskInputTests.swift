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

final class CLOCTaskInput: ZZTaskInput {
    private(set) var text: String?
    var onSent: ZZTaskInput.SendCompletion?
    
    func set(text: String?) {
        self.text = text
    }
    
    func send() {
        guard let text = text else { return }
        
        let data = parse(text: text)
        onSent?(data)
    }
    
    private func parse(text: String) -> (title: String, description: String?) {
        var result: (String, String?) = ("", nil)
        
        let substrings = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        
        if let title = substrings.first {
            result.0 = String(title)
        }
        
        if substrings.count > 1 , let desc = substrings.last {
            result.1 = String(desc)
        }
        
        return result
    }
}

class ZZTaskInputTests: XCTestCase {
    
    func test_init_textIsEmpty() {
        let sut = CLOCTaskInput()
        
        XCTAssertNil(sut.text)
    }
    
    func test_send_doesNotDeliverIfTextIsEmpty() {
        let sut = CLOCTaskInput()
        
        expect(sut, toCompleteWith: .none) {
            sut.send()
        }
    }

    func test_send_deliversTitleAndDescriptionIfTextIsNotEmpty() {
        let title = "title"
        let description = "desc"
        let sut = CLOCTaskInput()
        
        expect(sut, toCompleteWith: (title, description)) {
            sut.set(text: [title, description].joined(separator: "\n"))
            sut.send()
        }
    }
    
    // MARK: - Helpers
    
    private func expect(_ sut: CLOCTaskInput, toCompleteWith expected: (title: String, description: String?)?, when action: () -> Void) {
        let exp = expectation(description: "waiting for completion...")
        exp.isInverted = expected == nil
        
        sut.onSent = { (received) in
            if let expected = expected {
                XCTAssertEqual(received.title, expected.title)
                XCTAssertEqual(received.description, expected.description)
            } else {
                XCTFail("expected to not get completion")
            }

            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
