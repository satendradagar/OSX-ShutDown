//
//  Dictionary+Utility.swift
//  ShutDown
//
//  Created by Satendra Dagar on 02/02/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation

extension Dictionary {
    static func contentsOf(path: URL) -> Dictionary<String, AnyObject> {
        let data = try! Data(contentsOf: path)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        
        return plist as! [String: AnyObject]
    }
}
