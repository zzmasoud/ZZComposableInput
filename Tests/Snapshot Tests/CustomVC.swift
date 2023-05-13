//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit

final class CustomVC: UIViewController {
    @IBOutlet private var logLabel: UILabel!
    @IBOutlet public var resultLabel: UILabel!
    @IBOutlet public var segmentedControl: UISegmentedControl!
    @IBOutlet public var tableView: UITableView!
    
    public func log(selectedItems: [Int: [String]]) {
        var text = ""
        text += "Domain: "
        text += selectedItems[0]!.isEmpty ? "⭕️" : "✅"
        text += "\n"
        text += "Divider: "
        text += selectedItems[1]!.isEmpty ? "⭕️" : "✅"
        text += "\n"
        text += "Username : "
        text += selectedItems[2]!.isEmpty ? "⭕️" : "✅"
        
        logLabel.text = text
        resultLabel.text = (selectedItems[0] ?? []).joined() + (selectedItems[1] ?? []).joined() + (selectedItems[2] ?? []).joined()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log(selectedItems: [0: [], 1: [], 2: []])
    }
}
 
