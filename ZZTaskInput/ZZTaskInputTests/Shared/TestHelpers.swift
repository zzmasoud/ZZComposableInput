//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

enum MockSection: Int {
    case section0 = 0, section1, section2, section3
}

extension XCTestCase {
    func getSection() -> Int {
        return MockSection.section0.rawValue
    }

    func getSection2() -> Int {
        return MockSection.section1.rawValue
    }
    
    func makeItems() -> [NEED_TO_BE_GENERIC] {
        return (1...10).map { _ in NEED_TO_BE_GENERIC(id: UUID(), title: UUID().uuidString) }
    }
    
    func makeError() -> NSError {
        NSError(domain: "error", code: -1)
    }
}
