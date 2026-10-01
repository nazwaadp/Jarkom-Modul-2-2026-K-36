#!/bin/bash

# SOAL 8 - Reverse zone (1.229.192, 2.229.192, 4.229.192)

node_prab() {
# [NODE: prab] -> /etc/bind/named.conf.local (tambah zona reverse master)
cat <<'EOF' >> /etc/bind/named.conf.local
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

# [NODE: prab] -> /etc/bind/k36/1.229.192.in-addr.arpa  (vault & core)
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

# [NODE: prab] -> /etc/bind/k36/2.229.192.in-addr.arpa  (abbey)
cat <<'EOF' > /etc/bind/k36/2.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     abbey.k36.com.
EOF

# [NODE: prab] -> /etc/bind/k36/4.229.192.in-addr.arpa  (penny)
cat <<'EOF' > /etc/bind/k36/4.229.192.in-addr.arpa
$TTL    604800
@       IN      SOA     prab.k36.com. root.k36.com. ( 2026092901 604800 86400 2419200 604800 )
@       IN      NS      prab.k36.com.
@       IN      NS      tedd.k36.com.
2       IN      PTR     penny.k36.com.
EOF

service named restart || service bind9 restart
}

node_tedd() {
# [NODE: tedd] -> /etc/bind/named.conf.local (tambah zona reverse slave)
cat <<'EOF' >> /etc/bind/named.conf.local
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
service named restart || service bind9 restart
}

case "$1" in prab) node_prab ;; tedd) node_tedd ;; *) echo "Pakai: bash soal8.sh <prab|tedd>" ;; esac
