#!/bin/bash
# Nomor 5: Penamaan Hostname
echo "rootkit" > /etc/hostname
hostname rootkit
echo "127.0.0.1 rootkit" >> /etc/hosts

# Konfigurasi Network & NAT
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.229.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.229.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.229.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.229.4.1
	netmask 255.255.255.0

auto eth5
iface eth5 inet static
	address 192.229.5.1
	netmask 255.255.255.0

	up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.229.0.0/16
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.168.122.1
EOF