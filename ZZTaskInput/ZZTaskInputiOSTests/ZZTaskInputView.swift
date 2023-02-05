//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import UIKit
import ZZTaskInput

final class ZZTaskInputView: UIView {
    let textField: UITextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["date", "time", "project", "weekdaysRepeat"])
    let selectedSectionLabel = UILabel()
    private var inputController: DefaultTaskInput?
    
    convenience init(inputController: DefaultTaskInput) {
        self.init()
        self.inputController = inputController
        
        setupTextField()
        setupSegmentedControl()
        setupSectionLabel()
    }

    private func setupTextField() {
        self.addSubview(textField)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = -1
        segmentedControl.addTarget(self, action: #selector(selectSection), for: .valueChanged)
    }
    
    private func setupSectionLabel() {
        selectedSectionLabel.isHidden = true
    }
    
    @objc private func selectSection() {
        let index = segmentedControl.selectedSegmentIndex
        inputController?.select(section: CLOCSelectableProperty(rawValue: index)!, withPreselectedItems: nil, completion: { [weak self] _ in
            self?.selectedSectionLabel.isHidden = false
        })
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.window != nil {
            self.textField.becomeFirstResponder()
        }
    }
}

class ZZTaskInputViewTests: XCTestCase {
    
    func test_init_doesNotLoadItems() {
        let (_, inputController) = makeSUT()
        
        XCTAssertEqual(inputController.loadCallCount, 0)
    }

    func test_didMoveToWindow_makesTextFieldFirstResponder() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.isTextFieldFirstResponder)
        
        // Adding the view to window will trigger `didMoveToWindow`
        let window = UIWindow()
        window.addSubview(sut)
        
        XCTAssertTrue(sut.isTextFieldFirstResponder)
    }
    
    func test_selectAnySection_loadsItems() {
        let (sut, inputController) = makeSUT()

        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: ["a", "b", "c"])
        
        XCTAssertEqual(inputController.loadCallCount, 1)
    }
    
    func test_selectAnySection_showsSelectedSectionTextAfterLoading() {
        let (sut, inputController) = makeSUT()

        XCTAssertTrue(sut.isSectionLabelHidden)
        
        sut.simulateSelection(section: 0)
        inputController.loader.completeRetrieval(with: ["a", "b", "c"])

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
