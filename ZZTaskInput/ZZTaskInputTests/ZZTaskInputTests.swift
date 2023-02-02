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
        guard let text = text, !text.isEmpty else { return }
        
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
    
    func test_init_textIsNil() {
        let sut = CLOCTaskInput()
        
        XCTAssertNil(sut.text)
    }
    
    func test_send_doesNotDeliverIfTextIsNilOrEmpty() {
        let sut = CLOCTaskInput()
        
        expect(sut, toCompleteWith: .none) {
            sut.send()
        }
        
        sut.set(text: "")
        expect(sut, toCompleteWith: .none) {
            sut.send()
        }
    }

    func test_send_deliversTitleAndDescriptionIfTextIsNotEmpty() {
        var title = "title"
        var description = "desc"
        let sut = CLOCTaskInput()
        
        // title + description
        expect(sut, toCompleteWith: (title, description)) {
            sut.set(text: [title, description].joined(separator: "\n"))
            sut.send()
        }
        
        // title + no description
        expect(sut, toCompleteWith: (title, nil)) {
            sut.set(text: title)
            sut.send()
        }
        
        // title + description with +1 new lines
        description = "desc\ndesc \n desc"
        expect(sut, toCompleteWith: (title, description)) {
            sut.set(text: [title, description].joined(separator: "\n"))
            sut.send()
        }
        
        // title with +2 new line + description with 1+ new lines
        title = "\n\ntitle"
        description = "desc\ndesc \n desc"
        expect(sut, toCompleteWith: ("title", description)) {
            sut.set(text: [title, description].joined(separator: "\n"))
            sut.send()
        }
        
        // title with +2 new line + no description
        title = "\n\ntitle"
        expect(sut, toCompleteWith: ("title", nil)) {
            sut.set(text: title)
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
