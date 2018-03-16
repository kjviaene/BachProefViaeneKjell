#!/bin/sh
pkg install -y git
mv /home/vagrant/FirewallScript/config.xml /cf/conf/
sudo -s
sudo chmod 777 /sbin/shutdown
sudo chown vagrant /sbin/shutdown
echo "Rebooting now!"
reboot
