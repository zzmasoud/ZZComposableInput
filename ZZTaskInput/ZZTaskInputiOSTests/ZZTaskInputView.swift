//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

final class ZZTaskInputView {
    init(loader: ZZTaskInputViewTests.LoaderSpy) {}
}

class ZZTaskInputViewTests: XCTestCase {
    
    func test_init_doesNotLoadItems() {
        let loader = LoaderSpy()
        let _ = ZZTaskInputView(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
