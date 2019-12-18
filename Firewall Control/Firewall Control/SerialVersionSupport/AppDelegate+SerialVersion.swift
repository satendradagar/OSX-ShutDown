//
//  SerialVersion.swift
//  Barrier Serial
//
//  Created by Satendra Dagar on 01/05/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation
import Cocoa

let registrationKey = "APP_RegisterED"

extension AppDelegate{
    
    @IBAction func showRegistrationWindow(_ sender: Any?) {
        
        
        let REGIST_KEY_PREFIX = "BAR-1"
//        if true == GDStudioAppDelegate.isAppstoreVersion() {
//            CBOrder.addNewOrder(withUser: "jason@appstore.com", andTransationId: "GDS1-MACA-PPST-ORE1")
//            //END of tracking HOOK
//        }
        if nil == registrationController {
//            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
            registrationController = MCRegistrationViewController(windowNibName: NSNib.Name(rawValue: "MCRegistrationViewController"))
            registrationController?.details = "In order for you to use Barrier you must first register. Registration allows us to provide better support and to inform you of new updates and upgrades we are about to release. Your information will not be shared with any third parties and you can unsubscribe at any time."
            registrationController?.mainTitle = "Register Barrier"
            //        registrationController.apiKey = @"da779503246c9f44aa569845d0b00c40-us4";
            //        registrationController.ListID = @"198b8a5e00";
            //
            registrationController?.apiKey = "da779503246c9f44aa569845d0b00c40-us4"
            registrationController?.listID = "3ab8bb99a3"
//            if GDStudioAppDelegate.isAppstoreVersion() {
//                registrationController.defaultKey = "GDS1-MACA-PPST-ORE1"
//            }
            registrationController?.mergeDateKey = "BASREGDT";

            registrationController?.setKeyValidationBlock({ (_ inputKey) -> Bool in
                
                if (inputKey?.count ?? 0) != 23 || false == inputKey?.hasPrefix(REGIST_KEY_PREFIX) {
                    return false
                }
                return true
            })
            
//            let weakSelf = self
            registrationController?.setSuccessRegistrationBlock({ (_ info:[AnyHashable:Any]?) in
             DictionaryStorage.setPropertyListValue(true, forKey: registrationKey)
                self.setupMenuBarMenu()
                self.menu.showActiveMenuOnly()
                
//                DictionaryStorage.setPropertyListValue(true, forKey: REGISTER_KEY)

            })
        }
        
        registrationController?.showWindow(sender)
    }
    
    func isApplicationActivated() -> Bool{
        
        return  DictionaryStorage.boolValueForKey(registrationKey)

    }
}
