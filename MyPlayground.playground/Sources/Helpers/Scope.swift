import Foundation

public func scope(of title: String, block: ()->Void) {
    print("\n----- \(title) ------")
    block()
}
