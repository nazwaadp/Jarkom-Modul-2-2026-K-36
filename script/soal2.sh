#!/bin/bash

# SOAL 2 - NAT di rootkit + akses internet via IP
# [NODE: rootkit] saja.
# Aturan NAT (MASQUERADE) ada di /etc/network/interfaces rootkit
# sebagai baris "up iptables -t nat -A POSTROUTING ..." ( soal1.sh).
# Di sini: resolver rootkit + IP forwarding.

# [NODE: rootkit] -> /etc/resolv.conf
cat <<'EOF' > /etc/resolv.conf
nameserver 192.168.122.1
EOF

# [NODE: rootkit] -> /etc/sysctl.d/99-ip-forward.conf
cat <<'EOF' > /etc/sysctl.d/99-ip-forward.conf
net.ipv4.ip_forward=1
EOF

sysctl --system
