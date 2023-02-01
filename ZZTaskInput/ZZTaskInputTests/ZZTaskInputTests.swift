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
        
        let exp = expectation(description: "waiting for completion...")
        exp.isInverted = true
        
        sut.onSent = { _ in
            XCTFail("expected to not get completion")
            exp.fulfill()
        }
        
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_send_deliversDataIfTextIsNotEmpty() {
        let sut = CLOCTaskInput()

        let exp = expectation(description: "waiting for completion...")
        
        sut.onSent = { _ in
            exp.fulfill()
        }
        
        sut.set(text: "Hello World!")
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_send_deliversTitleAndDescriptionProperly() {
        let title = "title"
        let description = "desc"
        
        let exp = expectation(description: "waiting for completion...")

        let sut = CLOCTaskInput()
        
        sut.onSent = { (received) in
            XCTAssertEqual(title, received.title)
            XCTAssertEqual(description, received.description)
            exp.fulfill()
        }
        
        sut.set(text: [title, description].joined(separator: "\n"))
        sut.send()
        
        wait(for: [exp], timeout: 1)
    }
}
