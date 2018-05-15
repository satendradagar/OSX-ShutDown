//
//  Dictionary+Utility.swift
//  ShutDown
//
//  Created by Satendra Dagar on 02/02/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation

extension Dictionary {
    static func contentsOf(path: URL) -> Dictionary<String, Any> {
        if let data = try? Data(contentsOf: path){
            if let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            {
                return (plist as? [String: Any] ) ?? [String: Any]()
            }
        }
        
        return [String: Any]()
    }
    
    func write(atPath path:URL) throws {
        
        let data = try PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: 0)
        try data.write(to: path)
    }

}
