//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

struct MockItem: AnyItem {
    let id: UUID
    let title: String
}

extension XCTestCase {
    func makeItems() -> [MockItem] {
        return (1...10).map { _ in MockItem(id: UUID(), title: UUID().uuidString) }
    }
    
    func makeError() -> NSError {
        NSError(domain: "error", code: -1)
    }
}
