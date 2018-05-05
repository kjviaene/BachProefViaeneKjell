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
set nat source rule 100 source address '172.16.0.0/16'
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
#set system name-server 172.16.0.10
#set service dns forwarding system
##Only allow dns requests for the specified domain to go through
#set service dns forwarding domain hogent.be server 10.0.2.3
#set service dns forwarding listen-on 'eth1'
### BACHELORPROEF CONFIGURATION
set system name-server 10.0.2.3
set service dns forwarding system
set service dns forwarding domain avalon.lan server 172.16.0.10
set service dns forwarding listen-on 'eth1'
##Firewall Settings / acl's
## The group you want to apply the rules to
#set firewall group network-group INSIDE-NET network 172.16.0.0/16
#set firewall group address-group SCHOOL-NET address 178.62.144.90
#set firewall group address-group SCHOOL-NET address 193.190.173.131
## The group of things you want to block/allow
#set firewall group port-group TCP-ACCESS port 80
#set firewall group port-group TCP-ACCESS port 443
## Creating the rules of your Firewall
#set firewall name ACCESS-CONTROL description 'Blocking unwanted sites'
#set firewall name ACCESS-CONTROL default-action drop
#set firewall name ACCESS-CONTROL rule 200 action drop
#set firewall name ACCESS-CONTROL rule 200 destination group port-group TCP-ACCESS
#set firewall name ACCESS-CONTROL rule 200 source group network-group INSIDE-NET
#set firewall name ACCESS-CONTROL rule 200 state established enable
#set firewall name ACCESS-CONTROL rule 200 state related enable
#set firewall name ACCESS-CONTROL rule 100 action accept
#set firewall name ACCESS-CONTROL rule 100 destination group address-group SCHOOL-NET
#set firewall name ACCESS-CONTROL rule 200 state established enable
#set firewall name ACCESS-CONTROL rule 200 state related enable

# Applying the rule set
#set interfaces ethernet eth0 firewall out name ACCESS-CONTROL
# Make configuration changes persistent
commit
save

# Fix permissions on configuration
sudo chown -R root:vyattacfg /opt/vyatta/config/active

# vim: set ft=sh
