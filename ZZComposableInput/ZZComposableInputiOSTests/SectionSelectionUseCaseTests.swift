//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput
@testable import ZZComposableInputiOS

final class SectionSelectionUseCaseTests: XCTestCase {
    
    func test_init_renderedSectionsAreEmpty() {
        let sut = makeSUT()

        XCTAssertEqual(sut.sectionedView!.numberOfSections, 0)
    }
    
    func test_viewDidLoad_addsSectionedViewIntoContainerView() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.sectionedViewContainer!.subviews.isEmpty)
        
        sut.viewDidLoad()

        XCTAssertEqual(sut.sectionedViewContainer!.subviews, [sut.sectionedView!.view])
    }
    
    func test_viewDidLoad_labelIsHidden() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.label!.isHidden)
    }
    
    func test_sectionedView_rendersSections() {
        let sut = makeSUT()
        
        sut.viewDidLoad()

        XCTAssertEqual(sut.sectionedView!.selectedSectionIndex, -1)
        XCTAssertTrue(sut.sectionedView!.isRendering(sections: sections))
    }
    
    func test_changingSection_rendersTitle() {
        let selection = 0
        let sut = makeSUT()
        sut.viewDidLoad()

        sut.sectionedView!.simulateSelection(section: selection)
        
        XCTAssertFalse(sut.label!.isHidden)
        XCTAssertEqual(sut.label!.text, sections[selection])
        
        sut.sectionedView!.simulateSelection(section: selection+1)
        
        XCTAssertFalse(sut.label!.isHidden)
        XCTAssertEqual(sut.label!.text, sections[selection+1])
    }
    
    // MARK: - Helpers
        
    private let sections = ["A", "B", "C", "D"]
    
    private func makeSUT() -> SectionsController {
        let controller = SectionsController()
        let delegate = SectionsControllerDelegateAdapter(
            sectionsPresenter: SectionsPresenter(
                titles: sections,
                view: WeakRefVirtualProxy(controller)))
        controller.delegate = delegate
        controller.sectionedViewContainer = UIView()
        controller.sectionedView = MockSectionedView()
        controller.label = UILabel()

        trackForMemoryLeaks(controller)
        trackForMemoryLeaks(delegate)
        
        return controller
    }
}
