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
    
    func view(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZZSelectableCell.id, for: indexPath) as! ZZSelectableCell
        cell.textLabel?.text = text
        cell.setSelected(isSelected(), animated: false)
        return cell
    }
}
