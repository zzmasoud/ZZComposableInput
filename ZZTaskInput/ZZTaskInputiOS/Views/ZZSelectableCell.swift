//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

public class ZZSelectableCell: UITableViewCell {
    static let id = "ZZSelectableCell"
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
