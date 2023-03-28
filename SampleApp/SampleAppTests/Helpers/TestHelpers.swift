//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput
import SampleApp

extension XCTestCase {
    func getSection() -> Int {
        return SampleApp.Category(rawValue: 0)!.rawValue
    }

    func getSection2() -> Int {
        return SampleApp.Category(rawValue: 1)!.rawValue
    }
    
    func makeItems() -> [AnyItem] {
        return (1...10).map { _ in MockItem(id: UUID(), title: UUID().uuidString) }
    }
    
    func makeError() -> NSError {
        NSError(domain: "error", code: -1)
    }
}
