//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest

final class ZZTaskInputView: UIView {
    let textField: UITextField = UITextField()
    
    convenience init(loader: ZZTaskInputViewTests.LoaderSpy) {
        self.init()
        setupTextField()
    }

    private func setupTextField() {
        self.addSubview(textField)
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
        let loader = LoaderSpy()
        let _ = ZZTaskInputView(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_didMoveToWindow_makesTextFieldFirstResponder() {
        let loader = LoaderSpy()
        let sut = ZZTaskInputView(loader: loader)
        
        XCTAssertFalse(sut.textField.isFirstResponder)
        
        // Adding the view to window will trigger `didMoveToWindow`
        let window = UIWindow()
        window.addSubview(sut)
        
        XCTAssertTrue(sut.textField.isFirstResponder)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
