//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import UIKit
import ZZTaskInput

final class ZZTaskInputView: UIView {
    let textField: UITextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["date", "time", "project", "weekdaysRepeat"])
    private var inputController: DefaultTaskInput?
    
    convenience init(inputController: DefaultTaskInput) {
        self.init()
        self.inputController = inputController
        
        setupTextField()
        setupSegmentedControl()
    }

    private func setupTextField() {
        self.addSubview(textField)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(selectSection), for: .valueChanged)
    }
    
    @objc private func selectSection() {
        let index = segmentedControl.selectedSegmentIndex
        inputController?.select(section: CLOCSelectableProperty(rawValue: index)!, withPreselectedItems: nil, completion: { _ in })
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

        XCTAssertFalse(sut.textField.isFirstResponder)
        
        // Adding the view to window will trigger `didMoveToWindow`
        let window = UIWindow()
        window.addSubview(sut)
        
        XCTAssertTrue(sut.textField.isFirstResponder)
    }
    
    func test_selectAnySection_loadsItems() {
        let (sut, inputController) = makeSUT()

        sut.simulateSectionSelection()
        
        XCTAssertEqual(inputController.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ZZTaskInputView, inputController: TaskInputSpy) {
        let inputController = TaskInputSpy()
        let sut = ZZTaskInputView(inputController: inputController)
        return (sut, inputController)
    }
    
    class TaskInputSpy: DefaultTaskInput {
        let textParser = MockTextParser()
        let loader = ItemLoaderSpy()
        
        var loadCallCount: Int { loader.receivedMessages.count }
        
        override func select(section: CLOCSelectableProperty, withPreselectedItems: [DefaultTaskInput.Data.Item]?, completion: @escaping DefaultTaskInput.FetchItemsCompletion) {
            loader.loadItems(for: section) { _ in }
        }
    }
}

extension ZZTaskInputView {
    func simulateSectionSelection() {
        segmentedControl.simulateSelectingItem(at: 1)
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
