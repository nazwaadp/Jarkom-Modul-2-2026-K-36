#!/bin/bash
# Nomor 5: Hostname
echo "prab" > /etc/hostname
hostname prab
echo "127.0.0.1 prab" >> /etc/hosts

# Nomor 4: Resolver dan Network
cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.1.2
	netmask 255.255.255.0
	gateway 192.229.1.1
EOF
cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

apt update && apt install bind9 -y
mkdir -p /etc/bind/jarkom

# Nomor 4 & 8: Konfigurasi Zone Forward & Reverse (Master)
cat <<'EOF' > /etc/bind/named.conf.local
zone "k36.com" {
    type master;
    notify yes;
    also-notify { 192.229.1.3; };
    allow-transfer { 192.229.1.3; };
    file "/etc/bind/jarkom/k36.com";
};
zone "1.229.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.229.1.3; };
    allow-transfer { 192.229.1.3; };
    file "/etc/bind/jarkom/1.229.192.in-addr.arpa";
};
zone "2.229.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.229.1.3; };
    allow-transfer { 192.229.1.3; };
    file "/etc/bind/jarkom/2.229.192.in-addr.arpa";
};
zone "4.229.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.229.1.3; };
    allow-transfer { 192.229.1.3; };
    file "/etc/bind/jarkom/4.229.192.in-addr.arpa";
};
EOF

cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    dnssec-validation no;
    allow-query { any; };
    auth_nxdomain no;
    listen-on-v6 { any; };
};
EOF

# Nomor 4, 5, dan 7: Isi Zone Master k36.com
cat <<'EOF' > /etc/bind/jarkom/k36.com
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092902 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
@       IN      A       192.229.4.2
prab    IN      A       192.229.1.2
tedd    IN      A       192.229.1.3
rootkit IN      A       192.229.1.1
alpha   IN      A       192.229.3.2
beta    IN      A       192.229.3.3
gamma   IN      A       192.229.3.4
delta   IN      A       192.229.5.2
epsilon IN      A       192.229.4.3
penny   IN      A       192.229.4.2
abbey   IN      A       192.229.2.2
obladi  IN      A       192.229.1.4
desmond IN      A       192.229.1.5
oblada  IN      A       192.229.1.6
molly   IN      A       192.229.1.7
vault   IN      A       192.229.1.4
vault   IN      A       192.229.1.5
core    IN      A       192.229.1.6
core    IN      A       192.229.1.7
www     IN      CNAME   penny.k36.com.
static  IN      CNAME   abbey.k36.com.
EOF

# Nomor 8: Reverse Zones
cat <<'EOF' > /etc/bind/jarkom/1.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
4       IN      PTR     vault.k36.com.
5       IN      PTR     vault.k36.com.
6       IN      PTR     core.k36.com.
7       IN      PTR     core.k36.com.
EOF

cat <<'EOF' > /etc/bind/jarkom/2.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     abbey.k36.com.
EOF

cat <<'EOF' > /etc/bind/jarkom/4.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     penny.k36.com.
EOF

service bind9 restart