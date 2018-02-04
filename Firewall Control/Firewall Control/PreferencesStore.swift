//
//  PreferencesStore.swift
//  calendar
//
//  Created by Satendra Singh on 5/8/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Cocoa

class PreferencesStore: NSObject {
    
    static let sharedInstance = PreferencesStore()
    
    let defaults = UserDefaults.standard
    
    fileprivate override init() {
        
        super.init()
  //  5th June convert swift 3.0.
       
    }
    
    func storeCamera(status:Bool)
    {
        self.defaults.set(status, forKey: "CAMERA_STATUS")
        self.defaults.synchronize()
    }
    
    func cameraStatus() -> Bool{
        
        let dict = defaults.bool(forKey: "CAMERA_STATUS")
        return dict
    }
}
