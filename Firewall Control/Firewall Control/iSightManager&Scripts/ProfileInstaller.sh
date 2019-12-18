#!/bin/sh
#
configPath="$(dirname "$0")/camera-disabler.mobileconfig"
echo $configPath
#sudo /usr/bin/profiles -I -F $configPath
profiles -I -F $configPath
