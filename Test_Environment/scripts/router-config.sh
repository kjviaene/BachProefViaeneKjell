#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure

# Fix for error "INIT: Id "TO" respawning too fast: disabled for 5 minutes"
delete system console device ttyS0

#
# Basic settings
#
set system host-name 'Router'
set system domain-name avalon.lan
#set service ssh port '22'

#
# IP settings
#
set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description WAN
set interfaces ethernet eth1 address 172.16.255.254/16
set interfaces ethernet eth1 description inside

#
# Static routing
#
# set protocols static route 172.16.0.0/17 next-hop 172.16.255.254 distance '1'
#
# Network Address Translation
#
set nat source rule 100 outbound-interface eth0
set nat source rule 100 translation address masquerade

#
# Time
#
delete system ntp
set system ntp server be.pool.ntp.org
set system ntp server be.pool.ntp.org prefer
set system time-zone Europe/Brussels
#
# Domain Name Service
#
set system name-server 172.16.0.10
set service dns forwarding system
set service dns forwarding domain hogent.be server 10.0.2.3
set service dns forwarding listen-on 'eth1'

# Make configuration changes persistent
commit
save

# Fix permissions on configuration
sudo chown -R root:vyattacfg /opt/vyatta/config/active

# vim: set ft=sh
