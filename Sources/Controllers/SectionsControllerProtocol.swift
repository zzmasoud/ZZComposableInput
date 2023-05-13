//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol SectionsControllerProtocol: AnyObject, SectionsView {
    var delegate: SectionsControllerDelegate? { get set }
    var sectionedView: (any SectionedViewProtocol)? { get }
}
