#!/bin/bash

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
mkdir -p /etc/bind/k36

# Nomor 4 & 8: Konfigurasi Zone Forward & Reverse (Master)
cat <<'EOF' > /etc/bind/named.conf.local
zone "k36.com" {
    type master;
    file "/etc/bind/k36/k36.com";
    allow-transfer { 192.229.1.3; };
    notify yes;
};
zone "1.229.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k36/1.229.192.in-addr.arpa";
    allow-transfer { 192.229.1.3; };
    notify yes;
};
zone "2.229.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k36/2.229.192.in-addr.arpa";
    allow-transfer { 192.229.1.3; };
    notify yes;
};
zone "4.229.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k36/4.229.192.in-addr.arpa";
    allow-transfer { 192.229.1.3; };
    notify yes;
};
EOF

cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

# Nomor 4, 5, dan 7: Isi Zone Master k36.com
cat <<'EOF' > /etc/bind/k36/k36.com
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092902 604800 86400 2419200 604800 )

@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.

prab    IN      A       192.229.1.2
tedd    IN      A       192.229.1.3

@       IN      A       192.229.4.2

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
cat <<'EOF' > /etc/bind/k36/1.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
4       IN      PTR     vault.k36.com.
5       IN      PTR     vault.k36.com.
6       IN      PTR     core.k36.com.
7       IN      PTR     core.k36.com.
EOF

cat <<'EOF' > /etc/bind/k36/2.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     abbey.k36.com.
EOF

cat <<'EOF' > /etc/bind/k36/4.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     penny.k36.com.
EOF

service named restart || service bind9 restart