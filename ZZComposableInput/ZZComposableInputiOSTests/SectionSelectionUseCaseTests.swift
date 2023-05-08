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
    
    func test_sectionedView_rendersSections() {
        let sut = makeSUT()
        
        sut.viewDidLoad()

        XCTAssertEqual(sut.sectionedView!.selectedSectionIndex, -1)
        XCTAssertEqual(sut.sectionedView!.numberOfSections, sections.count)
    }
    
    func test_viewDidLoad_labelIsHidden() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.label!.isHidden)
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
        controller.sectionedView = MockSectionedView()
        controller.label = UILabel()

        trackForMemoryLeaks(controller)
        trackForMemoryLeaks(delegate)
        
        return controller
    }
}

public final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    public init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: SectionsView where T: SectionsView {
    public func display(_ viewModel: SectionsViewModel) {
        object?.display(viewModel)
    }
    
    public func display(_ viewModel: SectionViewModel) {
        object?.display(viewModel)
    }
}
