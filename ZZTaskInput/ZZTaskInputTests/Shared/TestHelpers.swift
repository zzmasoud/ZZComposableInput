//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZTaskInput

extension XCTestCase {
    func getSection() -> CLOCSelectableProperty {
        return .date
    }

    func getSection2() -> CLOCSelectableProperty {
        return .time
    }
    
    func makeItems() -> [String] {
        return ["a", "b", "c"]
    }
    
    func makeError() -> NSError {
        NSError(domain: "error", code: -1)
    }
}
