//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

final class SectionsControllerDelegateAdapterTests: XCTestCase {
    
    func test_init_doesntSendAnyMessage() {
        let (_, view, callback) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
        XCTAssertTrue(callback.recievedSections.isEmpty)
    }
    
    func test_didRequestSections_messagesPresenter() {
        let (sut, view, callback) = makeSUT()
    
        sut.didRequestSections()
        
        XCTAssertEqual(view.messages, [.display(sections: sections, index: -1)])
        XCTAssertTrue(callback.recievedSections.isEmpty)
    }
    
    func test_didSelectSectionAt_messagePresenterAndCallback() {
        let section = 0
        let (sut, view, callback) = makeSUT()
        
        sut.didSelectSection(at: section)
        
        XCTAssertEqual(view.messages, [.display(section: sections[0])])
        XCTAssertEqual(callback.recievedSections, [0])
    }
    
    // MARK: - Helpers
    
    private let sections = ["A", "B", "C"]
    
    func makeSUT() -> (sut: SectionsControllerDelegateAdapter, view: ViewSpy, callback: CallBackSpy) {
        let view = ViewSpy()
        let presenter = (SectionsPresenter(titles: sections, view: view))
        let callback = CallBackSpy()
        
        let sut = SectionsControllerDelegateAdapter(sectionsPresenter: presenter, sectionLoadCallback: { callback.add(section: $0)})
        
        return (sut, view, callback)
    }
    
    class CallBackSpy {
        private(set) var recievedSections = [Int]()
        
        func add(section: Int) {
            recievedSections.append(section)
        }
    }
}
