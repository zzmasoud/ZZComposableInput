//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

public protocol ZZTaskInput {
    associatedtype Data
    typealias SendCompletion = (Data) -> Void

    var onSent: SendCompletion? { get }
    func send()
}
