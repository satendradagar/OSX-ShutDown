//
//  DictionaryStorage.swift
//  Barrier
//
//  Created by Satendra Dagar on 04/05/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation

class DictionaryStorage: NSObject {
    
    static func setPropertyListValue(_ value: Any?, forKey key: String) {
        
        let filePath = DictionaryStorage.applicationSupportFilePath()
        let url = URL.init(fileURLWithPath: filePath ?? "")
        var propertyList = Dictionary<String, Any>.contentsOf(path: url)
  
        propertyList[key] = value
        do {
            
            try propertyList.write(atPath: url)
            
        } catch {
            print("\(error)")
            
        }
    }
    
    static func applicationSupportFilePath() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let applicationSupportDirectory = paths.first
        let filePath = URL(fileURLWithPath: applicationSupportDirectory ?? "").appendingPathComponent("barrier_serial_Reg.content").path
        return filePath
    }
    
    static func boolValueForKey(_ key:String) -> Bool {
        let filePath = applicationSupportFilePath()
        let url = URL.init(fileURLWithPath: filePath ?? "")
        var propertyList = Dictionary<String, Any>.contentsOf(path: url)
        if let strVal = (propertyList[key] as? String){
            return strVal.boolValue()
        }
        if let boolVal = (propertyList[key] as? Bool){
            return boolVal
        }

        return false
    }
    
}
