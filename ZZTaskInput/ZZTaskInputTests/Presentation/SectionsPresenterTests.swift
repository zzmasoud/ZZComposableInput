//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  
 
import XCTest

final class SectionsPresenter {
    init(view: Any) {}
}

class SectionsPresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let view = ViewSpy()
        
        _ = SectionsPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
 
