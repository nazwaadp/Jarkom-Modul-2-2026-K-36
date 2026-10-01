#!/bin/bash

# SOAL 4 - DNS authoritative k36.com (master prab, slave tedd)

node_prab() {
# [NODE: prab]
apt update && apt install bind9 -y
mkdir -p /etc/bind/k36

# [NODE: prab] -> /etc/bind/named.conf.local  (zona forward master)
cat <<'EOF' > /etc/bind/named.conf.local
zone "k36.com" {
    type master;
    file "/etc/bind/k36/k36.com";
    allow-transfer { 192.229.1.3; };
    notify yes;
};
EOF

# [NODE: prab] -> /etc/bind/named.conf.options
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

# [NODE: prab] -> /etc/bind/k36/k36.com  (SOA, NS, A prab/tedd, A apex -> penny)
cat <<'EOF' > /etc/bind/k36/k36.com
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092902 604800 86400 2419200 604800 )

@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.

prab    IN      A       192.229.1.2
tedd    IN      A       192.229.1.3

@       IN      A       192.229.4.2
EOF

service named restart || service bind9 restart
}

node_tedd() {
# [NODE: tedd]
apt update && apt install bind9 -y

# [NODE: tedd] -> /etc/bind/named.conf.local  (zona forward slave)
cat <<'EOF' > /etc/bind/named.conf.local
zone "k36.com" {
    type slave;
    masters { 192.229.1.2; };
    file "/var/lib/bind/k36.com";
};
EOF

# [NODE: tedd] -> /etc/bind/named.conf.options
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
service named restart || service bind9 restart
}

case "$1" in prab) node_prab ;; tedd) node_tedd ;; *) echo "Pakai: bash soal4.sh <prab|tedd>" ;; esac
