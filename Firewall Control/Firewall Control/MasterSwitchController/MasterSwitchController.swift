//
//  MasterSwitchController.swift
//  ShutDown
//
//  Created by Satendra Dagar on 09/02/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation
import CoreWLAN

class MasterSwitchController: NSObject {
    
    static let sharedInstance = MasterSwitchController()

    let currentInterface = CWWiFiClient.shared().interface()
    
    var isPowered:Bool{
        get{
            if let isInterface = currentInterface {
                return isInterface.powerOn()
            }
            return false
        }
    }
    
    var bluetoothPower:Bool{
        get{
            BTSetPowerState(1)
            return true
        }
    }
    
    func toggleMasterSwitch(status:Bool) {
        do {
            try currentInterface?.setPower(status)
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }
        catch {
            print("Something went wrong, are you feeling OK?")
            
        };
        if status == true{
            BTSetPowerState(1)

        }
        else{
            BTSetPowerState(0)

        }
    }

}
