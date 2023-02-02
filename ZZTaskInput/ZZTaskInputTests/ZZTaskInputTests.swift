//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

protocol ZZTextParser {
    associatedtype Parsed
    func parse(text: String) -> Parsed
}

final class CLOCTextParser: ZZTextParser {
    typealias Parsed = (title: String, description: String?)
    
    func parse(text: String) -> (title: String, description: String?) {
        var result: (String, String?) = ("", nil)
        
        let components = text.split(separator: "\n")
        
        if let title = components.first {
            result.0 = String(title)
        }
        
        if components.count > 1 {
            result.1 =
            String(
                components[1..<components.count]
                .joined(separator: "\n")
            )
            .trimmingCharacters(in: .whitespaces)
        }
        
        return result
    }
}

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
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmpty() {
        let title = "title"
        let description = "desc"
        let sut = makeSUT()
        
        // title + description
        expect(sut, toCompleteWith: (title, description)) {
            sut.set(text: [title, description].joined(separator: "\n"))
            sut.send()
        }
    }
    
    func test_send_deliversTitleOnlyIfTextIsNotEmptyAndNoDescription() {
        let title = "title"

        let sut = makeSUT()
        
        // title + no description
        expect(sut, toCompleteWith: (title, nil)) {
            let titleWithNewLines = "\n\n" + title + "\n\n"
            sut.set(text: titleWithNewLines)
            sut.send()
        }
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndDescriptionHasMultipleNewLines() {
        let title = "title"
        let description = "desc"
        
        let sut = makeSUT()
        
        // title + description with new lines
        expect(sut, toCompleteWith: (title, description)) {
            let descriptionWithNewLines = "\n\n" + description + "\n\n"
            sut.set(text: [title, descriptionWithNewLines].joined(separator: "\n"))
            sut.send()
        }
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndTitleHasMultipleNewLines() {
        let title = "title"
        let description = "desc"
        
        let sut = makeSUT()
        
        // title + description with new lines
        expect(sut, toCompleteWith: (title, description)) {
            let titleWithNewLines = "\n\n" + title + "\n\n"
            sut.set(text: [titleWithNewLines, description].joined(separator: "\n"))
            sut.send()
        }
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndBothHaveMultipleNewLines() {
        let title = "title"
        let description = "desc"
        
        let sut = makeSUT()
        
        // title + description with new lines
        expect(sut, toCompleteWith: (title, description)) {
            let titleWithNewLines = "\n\n" + title + "\n\n"
            let descriptionWithNewLines = "\n\n" + description + "\n\n"
            sut.set(text: [titleWithNewLines, descriptionWithNewLines].joined(separator: "\n"))
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
