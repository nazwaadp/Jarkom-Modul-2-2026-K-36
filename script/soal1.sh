#!/bin/bash

# [NODE: rootkit] -> /etc/network/interfaces
# (baris "up iptables ... MASQUERADE" adalah NAT untuk SOAL 2)
node_rootkit() {
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
}

# [NODE: alpha] -> /etc/network/interfaces
node_alpha() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.3.2
	netmask 255.255.255.0
	gateway 192.229.3.1
EOF
}

# [NODE: beta] -> /etc/network/interfaces
node_beta() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.3.3
	netmask 255.255.255.0
	gateway 192.229.3.1
EOF
}

# [NODE: gamma] -> /etc/network/interfaces
node_gamma() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.3.4
	netmask 255.255.255.0
	gateway 192.229.3.1
EOF
}

# [NODE: delta] -> /etc/network/interfaces
node_delta() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.5.2
	netmask 255.255.255.0
	gateway 192.229.5.1
EOF
}

# [NODE: epsilon] -> /etc/network/interfaces
node_epsilon() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.4.3
	netmask 255.255.255.0
	gateway 192.229.4.1
EOF
}

# [NODE: prab] -> /etc/network/interfaces
node_prab() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.2
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

# [NODE: tedd] -> /etc/network/interfaces
node_tedd() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.3
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

# [NODE: abbey] -> /etc/network/interfaces
node_abbey() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.2.2
        netmask 255.255.255.0
        gateway 192.229.2.1
EOF
}

# [NODE: penny] -> /etc/network/interfaces
node_penny() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.4.2
        netmask 255.255.255.0
        gateway 192.229.4.1
EOF
}

# [NODE: obladi] -> /etc/network/interfaces
node_obladi() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.4
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

# [NODE: desmond] -> /etc/network/interfaces
node_desmond() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.5
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

# [NODE: oblada] -> /etc/network/interfaces
node_oblada() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.6
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

# [NODE: molly] -> /etc/network/interfaces
node_molly() {
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.7
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF
}

if declare -f "node_$1" > /dev/null; then "node_$1"; else
  echo "Pakai: bash soal1.sh <rootkit|alpha|beta|gamma|delta|epsilon|prab|tedd|abbey|penny|obladi|desmond|oblada|molly>"
fi