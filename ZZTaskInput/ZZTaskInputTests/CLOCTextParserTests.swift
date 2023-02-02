//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

protocol ZZTextParser {
    associatedtype Parsed
    
    var separator: Character { get }
    func parse(text: String) -> Parsed
}

final class CLOCTextParser: ZZTextParser {
    typealias Parsed = (title: String, description: String?)
    let separator: Character = "\n"
    
    func parse(text: String) -> (title: String, description: String?) {
        var result: (String, String?) = ("", nil)
        
        let components = text.split(separator: separator)
        
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

class CLOCTextParserTests: XCTestCase {
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmpty() {
        let title = "title"
        let description = "desc"
        let sut = makeSUT()
        
        let parsed = sut.parse(text: [title, description].joined(separator: "\n"))
       
        XCTAssertEqual(parsed.title, title)
        XCTAssertEqual(parsed.description, description)
    }
    
    func test_send_deliversTitleOnlyIfTextIsNotEmptyAndNoDescription() {
        let title = "title"
        let sut = makeSUT()

        let parsed = sut.parse(text: title)
       
        XCTAssertEqual(parsed.title, title)
        XCTAssertEqual(parsed.description, nil)
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndDescriptionHasMultipleNewLines() {
        let title = "title"
        let description = "desc"
        let sut = makeSUT()

        let descriptionWithNewLines = "\n\n" + description + "\n\n"
        let parsed = sut.parse(text: [title, descriptionWithNewLines].joined(separator: "\n"))
       
        XCTAssertEqual(parsed.title, title)
        XCTAssertEqual(parsed.description, description)
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndTitleHasMultipleNewLines() {
        let title = "title"
        let description = "desc"
        let sut = makeSUT()

        let titleWithNewLines = "\n\n" + title + "\n\n"
        let parsed = sut.parse(text: [titleWithNewLines, description].joined(separator: "\n"))
       
        XCTAssertEqual(parsed.title, title)
        XCTAssertEqual(parsed.description, description)
    }
    
    func test_send_deliversTitleAndDescriptionIfTextIsNotEmptyAndBothHaveMultipleNewLines() {
        let title = "title"
        let description = "desc"
        let sut = makeSUT()

        let titleWithNewLines = "\n\n" + title + "\n\n"
        let descriptionWithNewLines = "\n\n" + description + "\n\n"
        let parsed = sut.parse(text: [titleWithNewLines, descriptionWithNewLines].joined(separator: "\n"))
       
        XCTAssertEqual(parsed.title, title)
        XCTAssertEqual(parsed.description, description)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CLOCTextParser {
        let sut = CLOCTextParser()
        return sut
    }

}
