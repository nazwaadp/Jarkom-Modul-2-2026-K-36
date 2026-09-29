#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.1.3
        netmask 255.255.255.0
        gateway 192.229.1.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

apt update && apt install bind9 -y

# Nomor 4 & 8: Deklarasi Slave untuk Forward & Reverse
cat <<'EOF' > /etc/bind/named.conf.local
zone "k36.com" {
    type slave;
    masters { 192.229.1.2; };
    file "/var/lib/bind/k36.com";
};
zone "1.229.192.in-addr.arpa" {
    type slave;
    masters { 192.229.1.2; };
    file "/var/lib/bind/1.229.192.in-addr.arpa";
};
zone "2.229.192.in-addr.arpa" {
    type slave;
    masters { 192.229.1.2; };
    file "/var/lib/bind/2.229.192.in-addr.arpa";
};
zone "4.229.192.in-addr.arpa" {
    type slave;
    masters { 192.229.1.2; };
    file "/var/lib/bind/4.229.192.in-addr.arpa";
};
EOF

cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    dnssec-validation no;
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF
service bind9 restart