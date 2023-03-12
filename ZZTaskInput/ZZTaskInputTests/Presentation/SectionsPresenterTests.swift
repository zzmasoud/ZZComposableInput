//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  
 
import XCTest
import ZZTaskInput

final class SectionsPresenter {
    private let titles: [String]
    private let view: SectionsView
    
    init(titles: [String], view: SectionsView) {
        self.titles = titles
        self.view = view
    }
    
    func didRequestSections() {
        view.display(SectionsViewModel(
            titles: titles,
            selectedIndex: -1))
    }
}

class SectionsPresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didRequestSection_displaysTitlesAndInvalidSelectedIndexToView() {
        let (sut, view) = makeSUT()
        
        sut.didRequestSections()
        
        XCTAssertEqual(view.messages, [
            .display(titles: sectionTitles(), index: -1)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SectionsPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = SectionsPresenter(titles: sectionTitles(), view: view)
        
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)

        return (sut, view)
    }
    
    private func sectionTitles() -> [String] {
        return ["A", "B", "C", "D"]
    }
    
    private class ViewSpy: SectionsView {
        enum Message: Hashable {
            case display(titles: [String], index: Int)
        }
        
        var messages = [Message]()
        
        func display(_ viewModel: SectionsViewModel) {
            messages.append(.display(
                titles: viewModel.titles,
                index: viewModel.selectedIndex))
        }
        
        func display(_ viewModel: SectionViewModel) {
            
        }
    }
}
 
