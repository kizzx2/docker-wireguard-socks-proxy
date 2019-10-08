#!/bin/sh

set -e

ifname=$(basename $(ls -1 /etc/wireguard/*.conf | head -1) .conf)
wg-quick up /etc/wireguard/$ifname.conf
sed -i'' -e "s/__replace_me_ifname__/$ifname/" /etc/sockd.conf
/usr/sbin/sockd
