//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

extension UIView {
    func addSubviewWithConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let constraints = [
            view.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 0
            ),
            view.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: 0
            ),
            view.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 0
            ),
            view.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: 0
            )
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
