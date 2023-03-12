//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

class LoadResourcePresenter {
    private let view: Any
    
    init(view: Any) {
        self.view = view
    }
}

class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(view: view)
        
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)

        return (sut, view)
    }
    
    
    private class ViewSpy {
        enum Message: Hashable {
        }
        
        var messages = [Message]()
    }

}
