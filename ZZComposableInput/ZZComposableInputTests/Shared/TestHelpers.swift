//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

enum MockSection: Int {
    case section0 = 0, section1, section2, section3
}

struct MockItem: Hashable {
    let id: UUID
    let title: String
}

extension XCTestCase {
    func getSection() -> Int {
        return MockSection.section0.rawValue
    }

    func getSection2() -> Int {
        return MockSection.section1.rawValue
    }
    
    func makeItems() -> [MockItem] {
        return (1...10).map { _ in MockItem(id: UUID(), title: UUID().uuidString) }
    }
    
    func makeError() -> NSError {
        NSError(domain: "error", code: -1)
    }
}
