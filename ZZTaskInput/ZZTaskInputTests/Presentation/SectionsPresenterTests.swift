//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  
 
import XCTest

final class SectionsPresenter {
    init(view: Any) {}
}

class SectionsPresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SectionsPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = SectionsPresenter(view: view)
        
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)

        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
 
