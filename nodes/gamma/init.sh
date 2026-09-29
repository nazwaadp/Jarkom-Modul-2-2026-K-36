#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.4.4
	netmask 255.255.255.0
	gateway 192.229.3.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF