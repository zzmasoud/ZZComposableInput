//
//  Helpers.swift
//  ZZNewTaskViewTests
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import Foundation

class Task {}
class Project {}

extension Int {
    public var minute: TimeInterval {
        return TimeInterval(self) * 60
    }
    public var hour: TimeInterval {
        return TimeInterval(self) * 60 * 1.minute
    }
    public var day: TimeInterval {
        return Double(self) * 24 * 1.hour
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension String {
    var localized: String {
        // return localized string
        return self
    }
}

