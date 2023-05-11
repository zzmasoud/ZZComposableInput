//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol SectionedViewProtocol {
    associatedtype View
    var view: View { get }
    var selectedSectionIndex: Int { set get }
    var numberOfSections: Int { get }
    var onSectionChange: (() -> Void)? { set get }
    func reload(withTitles: [String])
}
