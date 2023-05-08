//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
@testable import ZZComposableInputiOS

final class SectionsControllerDelegateUseCaseTests: XCTestCase {
    
    func test_init_doesntRequestSectionsUponCreation() {
        let (_, delegate) = makeSUT()

        XCTAssertEqual(delegate.sectionsRequestCount, 0)
    }
    
    func test_viewDidLoad_delegatesSectionsRequest() {
        let (sut, delegate) = makeSUT()
        
        sut.viewDidLoad()
        
        XCTAssertEqual(delegate.sectionsRequestCount, 1)
    }
    
    func test_selectSection_delegatesSectionAt() {
        let (sut, delegate) = makeSUT()
        sut.viewDidLoad()

        sut.select(section: 0)
        sut.select(section: 1)
        sut.select(section: 0)
        XCTAssertEqual(delegate.sectionRequests, [0, 1, 0])
        XCTAssertEqual(delegate.sectionsRequestCount, 1)
   }
    
    // MARK: - Helpers
    
    private let sections = ["A", "B", "C", "D"]
    
    private func makeSUT() -> (sut: SectionsController, delegate: MockDelegate) {
        let controller = SectionsController()
        let delegate = MockDelegate()
        controller.delegate = delegate
        controller.sectionedViewContainer = UIView()
        controller.sectionedView = MockSectionedView()
        
        return (controller, delegate)
    }
    
    private class MockDelegate: SectionsControllerDelegate {
        private(set) var sectionsRequestCount = 0
        private(set) var sectionRequests = [Int]()
        
        func didRequestSections() {
            sectionsRequestCount += 1
        }
        
        func didSelectSection(at index: Int) {
            sectionRequests.append(index)
        }
    }
}
