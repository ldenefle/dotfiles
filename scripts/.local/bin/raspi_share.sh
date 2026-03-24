#!/bin/bash
DEVICE="enp0s13f0u2u4"
WIFI_INTERFACE="wlp164s0"
ROUTERIP=139.96.30.1 # 192.168.123.1
ip link set $DEVICE down
ip link set $DEVICE up
ip addr add $ROUTERIP/24 dev $DEVICE # arbitrary address
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl net.ipv4.ip_forward=1

# Iptables
iptables --flush
iptables -t nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

INTERNET=$WIFI_INTERFACE
LOCAL=$DEVICE
# Allow established connections from the public interface.
iptables -A INPUT -i $INTERNET -m state --state ESTABLISHED,RELATED -j ACCEPT

# Set up IP FORWARDing and Masquerading
iptables --table nat --append POSTROUTING --out-interface $INTERNET -j MASQUERADE
iptables --append FORWARD --in-interface $LOCAL -j ACCEPT

# Allow outgoing connections
iptables -A OUTPUT -j ACCEPT

#Config file: /etc/dhcpd.conf
#Database file: /var/lib/dhcp/dhcpd.leases # cat this to see if a device has been asigned a lease
#PID file: /var/run/dhcpd.pid
dhcpd $DEVICE 
