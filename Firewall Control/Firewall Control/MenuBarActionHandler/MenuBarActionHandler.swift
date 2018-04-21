//
//  MenuBarActionHandler.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
//https://apple.stackexchange.com/questions/313373/block-specific-apps-on-macos

/*
 sudo spctl --add --label "DeniedApps" /Applications/Adium.app
 
 spctl --remove --label "DeniedApps"
 spctl --remove --label "ApprovedApps"
 */

class MenuBarActionHandler: NSMenu {

    weak var statusItem: NSStatusItem?

    @IBOutlet weak var masterSwitch: NSMenuItem!
    
    @IBOutlet weak var cameraOff: NSMenuItem!
    
    @IBOutlet weak var micOff: NSMenuItem!
    
    @IBOutlet weak var firewallOff: NSMenuItem!
    
    @IBOutlet var stealthMode: NSMenuItem!//Optional, conditional
    
    @IBOutlet var blockAll: NSMenuItem!//Optional, conditional
    
    @IBOutlet weak var firewallPrefrence: NSMenuItem!
    
    @IBOutlet weak var quitApp: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.updateMenuWithCurrentStatus()
        let device = AVCaptureDevice.devices(for: .video)
        let selector = #selector(didReceivedCameraChange(notification:))
        //wsnnn fix (https://github.com/gyetvan-andras/cocoa-waveform/issues/5#issuecomment-19802466)
        NotificationCenter.default.addObserver(self, selector:selector , name: .AVCaptureInputPortFormatDescriptionDidChange, object: nil)
//        static let AVCaptureDeviceSubjectAreaDidChange
        print(device)
    }
    
    @objc func didReceivedCameraChange(notification:Notification)  {
        print("Changed\(notification)")
        
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
            let pidSet = ProcessAccessor.pidsAccessingPath("/Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera")
            print("\(pidSet)")
            var pidsToKill = [NSNumber]()
            var processNames = ""
            
            for pid in pidSet! {
                let app = NSRunningApplication.init(processIdentifier: pid_t(pid))
                if let name = app?.localizedName{
                    if name == "Barrier"{
                        continue
                    }
                    pidsToKill.append(pid)
                    processNames.append(name)
                    processNames.append(", ")
                }
                print(app?.localizedName)
            }
            if (pidsToKill.count > 0){
                
                //"Are you sure you want to kill apps:\(processNames)"
                let reply = NSUtilities.dialogOKCancel(question: "One or more apps are already using the Camera", text: "Do you want to Force Quit all apps using the Camera?\nSelecting Cancel will only apply to applications that are not currently using the camera.")
                if reply == true{
                    for pid in pidsToKill {
                        let app = NSRunningApplication.init(processIdentifier: pid_t(pid))
                        app?.terminate()
                    }
                }
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
                self.updateMenuForFirewall()

            }

        }
        else{
            
            TaskManager.runScript("FirewallEnable", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
                self.updateMenuForFirewall()

            }

        }
    }

    @IBAction func stealthModeClicked(_ sender: NSMenuItem) {
        
        let status = FirewallManager.stealthModeStatus()
        if status == true{
            TaskManager.runScript("FirewallStealthDisable", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
                self.updateMenuForFirewall()
            }
        }
        else{
            TaskManager.runScript("FirewallStealthEnable", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
                self.updateMenuForFirewall()
            }
        }
    }

    @IBAction func blockAllClicked(_ sender: NSMenuItem) {
      
        let status = FirewallManager.blockAllModeStatus()

        if status == true{
            TaskManager.runScript("FirewallUnBlockAll", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
//                self.updateMenuForFirewall()
            }
        }
        else{
            TaskManager.runScript("FirewallBlockAll", withArgs: [], responseHandling: { (message) in
                print("\(String(describing: message))")
            }) { (task) in
//                self.updateMenuForFirewall()
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
            return status != 0
        }
        return false
    }
    
    func updateMenuForFirewall() {

        let status = globalFirewallStatus()
        if status == false {
            self.firewallOff.title = "Turn On Firewall"
            self.statusItem?.image = #imageLiteral(resourceName: "toolbar_Off")
            self.stealthMode.isHidden = true
            self.blockAll.isHidden = true

        }
        else{
            self.firewallOff.title = "Turn Off Firewall"
            self.statusItem?.image = #imageLiteral(resourceName: "toolbar_On")
            self.stealthMode.isHidden = false
            self.blockAll.isHidden = false
            updateMenuForStealthMode()
            updateMenuForBlockAll()
        }
    }
    
    func updateMenuForBlockAll() {
        
        let status = FirewallManager.blockAllModeStatus()
        if status == false {
            self.blockAll.title = "Block All"
        }
        else{
            self.blockAll.title = "Unblock All"
        }
    }
    
    func updateMenuForStealthMode() {
        
        let status = FirewallManager.stealthModeStatus()
        if status == false {
            self.stealthMode.title = "Enable Stealth Mode "
        }
        else{
            self.stealthMode.title = "Disable Stealth Mode "
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
