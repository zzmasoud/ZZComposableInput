//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

class ZZSelectableCell: UITableViewCell {
    static let id = "ZZSelectableCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
