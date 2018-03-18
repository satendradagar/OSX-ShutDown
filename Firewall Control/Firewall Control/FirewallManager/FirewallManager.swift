//
//  FirewallManager.swift
//  ShutDown
//
//  Created by Satendra Dagar on 10/03/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

import Foundation

/*
Block all incoming traffic

/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall
/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
 /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall off;
 
 Stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on To check if stealth mode is enabled: /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
 
 https://superuser.com/questions/505128/deny-access-to-a-port-from-localhost-on-osx
 
 http://nomoa.com/bsd/gateway/pf/valid/pfctl.html
 
 https://www.experts-exchange.com/questions/23481637/How-do-I-unblock-the-port-25-in-my-mac-firewall.html
 
 https://forums.freebsd.org/threads/how-to-block-port-25-in.13969/
 
 https://forums.freebsd.org/threads/how-to-block-port-25-in.13969/
 
 sendmail_enable="NO"

 
 sendmail_enable="NO"
 sendmail_outbound_enable="NO"
 sendmail_msp_queue_flags="-L sm-msp-queue -Ac -q15m"
 sendmail_submit_flags="-L sm-mta -bd -q15m -ODaemonPortOptions=localhost"

 */

