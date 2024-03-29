//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

final class LoadResourcePresentationAdapterTests: XCTestCase {
    
    func test_init_doesntMessageLoader() {
        let (_,loader,_) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_init_doesntMessagePresenter() {
        let (_,_, view) = makeSUT()
        
        XCTAssertEqual(view.messages, [])
    }
    
    func test_selectSection_sendsDidStartLoadingMessage() {
        let (sut,_, view) = makeSUT()
        
        sut.selectSection(index: 0)
        
        XCTAssertEqual(view.messages, [.display(isLoading: true)])
    }
    
    func test_selectSection_sendsDidFinishLoadingMessageAfterLoaderCompletion() {
        let items = makeItems()
        let (sut, loader, view) = makeSUT()
        
        sut.selectSection(index: 0)
        loader.completeRetrieval(with: items)
        
        XCTAssertEqual(view.messages,[
            .display(isLoading: true),
            .display(isLoading: false),
            .display(items: items, index: 0)
        ])
    }
    
    func test_selectSection_sendsDidFinishLoadingMessageAfterLoaderFailureCompletion() {
        let error = makeError()
        let (sut, loader, view) = makeSUT()
        
        sut.selectSection(index: 0)
        loader.completeRetrieval(with: error)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(items: [], index: 0)
        ])
    }
    
    func test_selectSection_hasNoSideEffects() {
        let items = makeItems()
        let error = makeError()
        
        let (sut, loader, view) = makeSUT()
        
        sut.selectSection(index: 0)
        sut.selectSection(index: 1)
        
        loader.completeRetrieval(with: items, at: 0)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true),
            .display(isLoading: true),
        ])
        
        loader.completeRetrieval(with: error, at: 1)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true),
            .display(isLoading: true),
            .display(isLoading: false),
            .display(items: [], index: 1)
        ])
    }

    // MARK: - Helpers
    
    private typealias SUT = LoadResourcePresentationAdapter<ItemLoaderSpy>
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SUT, loader: ItemLoaderSpy, view: ViewSpy) {
        let loader = ItemLoaderSpy()
        let view = ViewSpy()
        let sut = SUT(loader: loader)
        sut.presenter = LoadResourcePresenter(loadingView: view, listView: view)
        
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, loader, view)
    }
}
