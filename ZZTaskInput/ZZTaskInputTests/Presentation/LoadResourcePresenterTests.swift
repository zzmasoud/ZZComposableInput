//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoading_displaysLoadingStarted() {
        let (sut, view) = makeSUT()

        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingResource_displaysResourcesAndStopsLoading() {
        let (sut, view) = makeSUT()
        let items = makeItems()
        let index = 0
        
        sut.didFinishLoading(with: items, at: index)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(items: items, index: index)
        ])
    }
    
    func test_didFinishLoadingWithError_displaysEmptyResourcesAndStopsLoading() {
        let (sut, view) = makeSUT()
        let error = makeError()
        let index = 0
        
        sut.didFinishLoading(with: error, at: index)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(items: [], index: index)
        ])
    }

    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(loadingView: view, listView: view)
        
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)

        return (sut, view)
    }
    
    private class ViewSpy: ResourceLoadingView, ResourceListView {
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(items: [NEED_TO_BE_GENERIC], index: Int)
        }
        
        var messages = [Message]()
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: ResourceListViewModel) {
            messages.append(.display(items: viewModel.items, index: viewModel.index))
        }
    }
}
