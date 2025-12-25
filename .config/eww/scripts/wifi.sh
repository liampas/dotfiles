#!/bin/bash

wifi_ssid=$(nmcli dev status | grep -q "connected" && echo 1)

echo "$wifi_ssid"
