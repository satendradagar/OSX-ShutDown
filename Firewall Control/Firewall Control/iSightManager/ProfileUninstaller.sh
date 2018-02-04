#!/bin/sh
#
configPath="$(dirname "$0")/camera-disabler.mobileconfig"
echo $configPath
#sudo /usr/bin/profiles -R -F $configPath
profiles -R -F $configPath
