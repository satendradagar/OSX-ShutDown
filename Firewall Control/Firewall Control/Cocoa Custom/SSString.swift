//
//  SSString.swift
//  intelliSheets
//
//  Created by Satendra Singh on 21/12/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }

    func boolValue() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
//    extension String {
//        func boolValue() -> Bool {
//            let trueValues = ["true", "yes", "1"]
//            let falseValues = ["false", "no", "0"]
//
//            let lowerSelf = self.lowercaseString
//
//            if contains(trueValues, lowerSelf) {
//                return true
//            } else if contains(falseValues, lowerSelf) {
//                return false
//            } else {
//                return false
//            }
//        }
//    }
}
