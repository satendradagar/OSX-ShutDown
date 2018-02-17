//
//  AppDelegate.swift
//  Firewall Control
//
//  Created by Satendra Dagar on 24/12/17.
//  Copyright © 2017 Satendra Dagar. All rights reserved.
//
/*
 PFCTL
 
 https://pleiades.ucsc.edu/hyades/PF_on_Mac_OS_X
 
 http://www.peachpit.com/articles/article.aspx?p=1573022&seqNum=3
 
 https://raymii.org/s/snippets/OS_X_-_Turn_firewall_on_or_off_from_the_command_line.html
 
 
 This command lets you turn the build in OS X firewall on and off, on both for specific services or essential services. It works with OS X 10.5, 10.6, 10.7 and 10.8. It also works via Apple Remote Desktop.
 
 To turn the firewall off:
 defaults read /Library/Preferences/com.apple.alf globalstate -int
 sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 0
 To turn the firewall on for specific applications/services:
 
 sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
 To turn the firewall on for essential services like DHCP and ipsec, block all the rest:
 
 sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
 
 */


import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var menu: MenuBarActionHandler!
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.menu = menu //set the menu
//        statusItem.title = "Firewall Control"
        menu.statusItem = statusItem
        menu.updateMenuForFirewall()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

