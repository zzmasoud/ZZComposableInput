//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZComposableInputiOS

extension SectionedViewProtocol {
    func simulateSelection(section: Int) {
        let segmented = self.view as! UISegmentedControl
        segmented.simulateSelectingItem(at: section)
    }
    
    func isRendering(sections: [String]) -> Bool {
        let segmented = self.view as! UISegmentedControl
        for (index, title) in sections.enumerated() {
            guard segmented.titleForSegment(at: index) == title else { return false }
        }
        return true
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

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
