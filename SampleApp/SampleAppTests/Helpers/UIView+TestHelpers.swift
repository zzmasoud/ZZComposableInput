//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
