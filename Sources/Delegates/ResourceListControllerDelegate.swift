//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ResourceListControllerDelegate {
    func didSelectResource(at: Int)
    func didDeselectResource(at: Int)
}
