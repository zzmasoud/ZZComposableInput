//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import UIKit
import ZZTaskInput
import ZZTaskInputiOS

class ZZTaskInputViewTests: XCTestCase {
    
    func test_loadItemsActions_requestSelectFromInputController() {
        let (sut, inputController) = makeSUT()
        XCTAssertEqual(inputController.loadCallCount, 0)
        
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: ["a", "b", "c"])
        XCTAssertEqual(inputController.loadCallCount, 1)
    }

    func test_didMoveToWindow_makesTextFieldFirstResponder() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.isTextFieldFirstResponder)
        
        // Adding the view to window will trigger `didMoveToWindow`
        let window = UIWindow()
        window.addSubview(sut)
        
        XCTAssertTrue(sut.isTextFieldFirstResponder)
    }
    
    func test_selectedSectionText_isVisibleWhenItemsIsLoaded() {
        let (sut, inputController) = makeSUT()
        XCTAssertTrue(sut.isSectionLabelHidden)
 
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: ["a", "b", "c"])
        XCTAssertFalse(sut.isSectionLabelHidden)

        sut.simulateSelection(section: 1)
        XCTAssertTrue(sut.isSectionLabelHidden)

        inputController.loader.completeRetrieval(with: .none, at: 1)
        XCTAssertFalse(sut.isSectionLabelHidden)

        sut.simulateSelection(section: 2)
        XCTAssertTrue(sut.isSectionLabelHidden)

        inputController.loader.completeRetrieval(with: NSError(domain: "-", code: -1), at: 2)
        XCTAssertFalse(sut.isSectionLabelHidden)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ZZTaskInputView, inputController: TaskInputSpy) {
        let inputController = TaskInputSpy()
        let sut = ZZTaskInputView(inputController: inputController)
        
        trackForMemoryLeaks(inputController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, inputController)
    }
    
    class TaskInputSpy: DefaultTaskInput {
        let textParser = MockTextParser()
        let loader = ItemLoaderSpy()
        
        var loadCallCount: Int { loader.receivedMessages.count }
        
        override func select(section: CLOCSelectableProperty, withPreselectedItems: [DefaultTaskInput.Data.Item]?, completion: @escaping DefaultTaskInput.FetchItemsCompletion) {
            loader.loadItems(for: section) { _ in
                completion(.failure(NSError(domain: "-", code: -1)))
            }
        }
    }
}

extension ZZTaskInputView {
    func simulateSelection(section: Int) {
        segmentedControl.simulateSelectingItem(at: section)
    }
    
    var isTextFieldFirstResponder: Bool {
        textField.isFirstResponder
    }
    
    var isSectionLabelHidden: Bool {
        selectedSectionLabel.isHidden
    }
}

extension UISegmentedControl {
    func simulateSelectingItem(at index: Int) {
        selectedSegmentIndex = index

        self.allTargets.forEach({ target in
            self.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({ selector in
                (target as NSObject).perform(Selector(selector))
            })
        })
    }
}
