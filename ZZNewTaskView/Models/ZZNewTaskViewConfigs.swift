//
//  ZZNewTaskViewConfigs.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/9/22.
//

import Foundation

open class ZZNewTaskViewConfigs: NSObject, NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return ZZNewTaskViewConfigs()
    }
    
    // default state
//    let buttonsDefaultTintColor: UIColor
//    let buttonsDefaultBGColor: UIColor
//
//    let buttonsFilledTintColor: UIColor
//    let buttonsFilledBGColor: UIColor
//
//    let tintColor: UIColor
//    let backgroundColor: UIColor
    
    let headerAttributes: [NSAttributedString.Key : Any]
    let bodyAttributes: [NSAttributedString.Key : Any]
    
    
    public init(
        headerAttributes: [NSAttributedString.Key : Any] = [:],
        bodyAttributes: [NSAttributedString.Key : Any] = [:]
    ) {
//        self.backgroundColor = backgroundColor
//        self.buttonsDefaultTintColor = buttonsDefaultTintColor
//        self.buttonsDefaultBGColor = buttonsDefaultBGColor
//        self.buttonsFilledTintColor = buttonsFilledTintColor
//        self.buttonsFilledBGColor = buttonsFilledBGColor
//        self.tintColor = tintColor

        self.headerAttributes = headerAttributes
        self.bodyAttributes = bodyAttributes
    }
}
