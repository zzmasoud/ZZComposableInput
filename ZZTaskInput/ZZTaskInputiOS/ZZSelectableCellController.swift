//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class ZZSelectableCellController {
    func view(text: String, isSelected: Bool) -> UITableViewCell {
        let cell = ZZSelectableCell()
        cell.textLabel?.text = text
        cell.setSelected(isSelected, animated: false)
        return cell
    }
}
