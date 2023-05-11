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

public protocol SectionsControllerDelegate {
    func didRequestSections()
    func didSelectSection(at: Int)
}

public protocol SectionsControllerProtocol: AnyObject, SectionsView {
    var delegate: SectionsControllerDelegate? { get set }
    var sectionedView: (any SectionedViewProtocol)? { get }
}
