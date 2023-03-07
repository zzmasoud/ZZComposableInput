//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

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
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CLOCTextParser<(title: String, description: String?)> {
        let sut = CLOCTextParser<(title: String, description: String?)>()
        return sut
    }
}
