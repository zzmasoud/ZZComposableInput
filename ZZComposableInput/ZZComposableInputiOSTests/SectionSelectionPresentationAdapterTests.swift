//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput
@testable import ZZComposableInputiOS

final class SectionSelectionPresentationAdapterTests: XCTestCase {
    
    func test_init_doesNotMessageLoader() {
        let (_,loader,_) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_init_doesNotMessagePresenter() {
        let (_,_, view) = makeSUT()
        
        XCTAssertEqual(view.messages, [])
    }

    // MARK: - Helpers
    
    private typealias SUT = SectionSelectionPresentationAdapter<ItemLoaderSpy>
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SUT, loader: ItemLoaderSpy, view: ViewSpy) {
        let loader = ItemLoaderSpy()
        let view = ViewSpy()
        let sut = SUT(loader: loader)
        let presenter = LoadResourcePresenter(loadingView: view, listView: view)
        
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, loader, view)
    }
}
