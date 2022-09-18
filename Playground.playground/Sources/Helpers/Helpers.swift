//
//  Helpers.swift
//  ZZNewTaskViewTests
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import Foundation

public class Task {}
public class Project {}

public extension Int {
    var minute: TimeInterval {
        return TimeInterval(self) * 60
    }
    var hour: TimeInterval {
        return TimeInterval(self) * 60 * 1.minute
    }
    var day: TimeInterval {
        return Double(self) * 24 * 1.hour
    }
}

public extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

public extension String {
    var localized: String {
        // return localized string
        return self
    }
}

