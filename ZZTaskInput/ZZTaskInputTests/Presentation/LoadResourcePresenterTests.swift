//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

class LoadResourcePresenter {
    private let loadingView: ResourceLoadingView
    
    init(loadingView: ResourceLoadingView) {
        self.loadingView = loadingView
    }
    
    func didStartLoading() {
        loadingView.display(ResourceLoadingViewModel(
            isLoading: true
        ))
    }
}

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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(loadingView: view)
        
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)

        return (sut, view)
    }
    
    
    private class ViewSpy: ResourceLoadingView {
        enum Message: Hashable {
            case display(isLoading: Bool)
        }
        
        var messages = [Message]()
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.append(.display(isLoading: true))
        }
    }
}
