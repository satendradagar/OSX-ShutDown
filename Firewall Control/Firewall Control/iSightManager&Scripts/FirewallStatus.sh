#!/bin/sh
#
status= defaults read /Library/Preferences/com.apple.alf globalstate -int
echo "$status"
