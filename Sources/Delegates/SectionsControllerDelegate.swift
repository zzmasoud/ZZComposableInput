//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol SectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}
