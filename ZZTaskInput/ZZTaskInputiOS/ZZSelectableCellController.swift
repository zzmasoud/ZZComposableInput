//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSelectableCellController {
    let text: String
    let isSelected: (() -> Bool)
    
    init(text: String, isSelected: @escaping (() -> Bool)) {
        self.text = text
        self.isSelected = isSelected
    }
    
    func view() -> UITableViewCell {
        let cell = ZZSelectableCell()
        cell.textLabel?.text = text
        cell.setSelected(isSelected(), animated: false)
        return cell
    }
}
