//
//  MenuBarActionHandler.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Foundation
import Cocoa

class MenuBarActionHandler: NSMenu {
    
    @IBOutlet weak var masterSwitch: NSMenuItem!
    
    @IBOutlet weak var cameraOff: NSMenuItem!
    
    @IBOutlet weak var micOff: NSMenuItem!
    
    @IBOutlet weak var firewallOff: NSMenuItem!
    
    @IBOutlet weak var firewallPrefrence: NSMenuItem!
    
    @IBOutlet weak var quitApp: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.updateMenuWithCurrentStatus()
    }
    
    @IBAction func didClickRecordAudio(_ sender: NSMenuItem) {
        print(MuteManager.currentState())
        print(MuteManager.currentStateFixed())

//        if (recordingController.isRecording()){
//            recordingController.recorder?.stop()
//            recordAudio.title = "Record Audio"
//
//        }
//        else{
//            recordingController.createRecorder()
//            recordingController.recorder?.record()
//            recordAudio.title = "Stop Recording"
//            self.updateFileRelatedMenu()
//        }
    }
    
    @IBAction func masterSwitchClicked(_ sender: NSMenuItem) {
        let status = MasterSwitchController.sharedInstance.isPowered
        MasterSwitchController.sharedInstance.toggleMasterSwitch(status: !status)
    }
    
    @IBAction func cameraOffClicked(_ sender: NSMenuItem) {
        
        let status = !PreferencesStore.sharedInstance.cameraStatus()
        if true == status {
            
            TaskManager.runScript("ProfileInstaller", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in

            }
        }
        else{
            TaskManager.runScript("ProfileUninstaller", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")

            }) { (task) in

            }
        }
        PreferencesStore.sharedInstance.storeCamera(status: status)
    }

    @IBAction func micOffClicked(_ sender: NSMenuItem) {
        _ = MuteManager .changeStateFixed()
        updateMenuForMicVolume()
    }

    @IBAction func firewallOffClicked(_ sender: NSMenuItem) {
        
        let status = globalFirewallStatus()
        if status == true{
            
            TaskManager.runScript("FirewallDisable", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
                
            }

        }
        else{
            
            TaskManager.runScript("FirewallEnable", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
                
            }

        }
    }

    @IBAction func firewallPrefrenceClicked(_ sender: NSMenuItem) {
        
        let urlString = "x-apple.systempreferences:com.apple.preference.security?Firewall"
        NSWorkspace.shared.open(URL(string: urlString)!)
    }
    
    @IBAction func didClickQuitApp(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
    
    func updateMenuWithCurrentStatus() {
        self.updateMenuForMicVolume()
        updateMenuForCamera()
        updateMenuForFirewall()
        updateMenuForMasterSwitch()
    }
    
    func updateMenuForMicVolume() {
        let micVolume = MuteManager .currentState()
        if micVolume > 0.0 {
            self.micOff.title = "Turn Off Microphone"
        }
        else{
            self.micOff.title = "Turn On Microphone"
        }
    }

    func updateMenuForCamera() {
        let status = PreferencesStore.sharedInstance.cameraStatus()
        if status == false {
            self.cameraOff.title = "Turn Off Camera"
        }
        else{
            self.cameraOff.title = "Turn On Camera"
        }
    }

    func globalFirewallStatus() -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .systemDomainMask, true)
        var path: String = paths[0]
        path = "\(path)/\("Preferences/com.apple.alf.plist")"
        path = path.replacingOccurrences(of: "/System", with: "")
        let url = URL(fileURLWithPath: path)
        let dict = Dictionary<String, AnyObject>.contentsOf(path: url)
        
//        let _dictionary = [AnyHashable: Any](contentsOfFile: path)
            // firewall status
//        let status = Int(_dictionary["globalstate"] ) ?? 0
        if let status = dict["globalstate"] as? Int {
            return status == 1
        }
        return false
    }
    
    func updateMenuForFirewall() {

        let status = globalFirewallStatus()
        if status == false {
            self.firewallOff.title = "Turn On Firewall"
        }
        else{
            self.firewallOff.title = "Turn Off Firewall"
        }
    }
    
    func updateMenuForMasterSwitch() {
        
        let status = MasterSwitchController.sharedInstance.isPowered
        if status == false {
            self.masterSwitch.title = "Connect Internet and Bluetooth"
        }
        else{
            self.masterSwitch.title = "Disconnect Internet and Bluetooth"
        }
    }
}

extension MenuBarActionHandler : NSMenuDelegate{
    
     public func menuWillOpen(_ menu: NSMenu){
        print("menuWillOpen")
        self.updateMenuWithCurrentStatus()
    }
    
     public func menuDidClose(_ menu: NSMenu){
        print("menuDidClose")

    }
    
}
