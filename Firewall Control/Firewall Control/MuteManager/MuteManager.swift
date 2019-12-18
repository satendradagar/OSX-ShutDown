//
//  MuteManager.swift
//  ShutDown
//
//  Created by Satendra Dagar on 21/01/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation

class MuteManager: NSObject {
    
   static func currentState() -> Double {
        let result: NSAppleEventDescriptor? = excecuteAppleScript("volume_sript")
//        let data: Data? = result?.data
//        var currentPosition: Double = 0
//        data?.getBytes(currentPosition, length: data?.count ?? 0)
        return result?.doubleValue  ?? 0.0
    }
    // return the correct microphone volume
    static func currentStateFixed() -> Double {
        let result: NSAppleEventDescriptor? = excecuteAppleScript("volume_sript")
        return result?.doubleValue ?? 0.0
    }
    
    static func changeState() -> Double {
        let result: NSAppleEventDescriptor? = excecuteAppleScript("mute_sript")
//        let data: Data? = result?.data
//        var currentPosition: Double = 0
//        data?.getBytes(currentPosition, length: data?.count ?? 0)
        return result?.doubleValue  ?? 0.0
    }
    
    static func changeStateFixed() -> Double {
        let result: NSAppleEventDescriptor? = excecuteAppleScript("mute_sript")
        return result?.doubleValue ?? 0.0
    }
    
    static func excecuteAppleScript(_ withName: String) -> NSAppleEventDescriptor {
        let path: String? = Bundle.main.path(forResource: withName, ofType: "scpt")
        let fileUrl = Foundation.URL.init(fileURLWithPath: path!)
        
//        var errors = [AnyHashable: Any]()
        var possibleError: NSDictionary?

        let appleScript: NSAppleScript? =  NSAppleScript.init(contentsOf: fileUrl, error: &possibleError)
        let res = (appleScript?.executeAndReturnError(&possibleError)) ?? NSAppleEventDescriptor()
        return res
//        return (try? appleScript?.execute()) ?? NSAppleEventDescriptor()

//        return (try? appleScript?.execute()) ?? NSAppleEventDescriptor()
    }

}
