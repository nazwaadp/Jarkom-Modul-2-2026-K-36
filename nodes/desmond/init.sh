#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.1.5
	netmask 255.255.255.0
	gateway 192.229.1.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

NAMA_NODE="desmond"      # UBAH MENJADI desmond JIKA DI NODE DESMOND
IP_NODE="192.229.1.5"   # UBAH MENJADI 192.229.1.5 JIKA DI NODE DESMOND

# Nomor 5: Hostname
echo "$NAMA_NODE" > /etc/hostname
hostname $NAMA_NODE
echo "127.0.0.1 $NAMA_NODE" >> /etc/hosts

# Nomor 9: Web Statis Apache & Autoindex
apt update && apt install apache2 -y
mkdir -p /arsip
echo "File percobaan di dalam arsip dari $NAMA_NODE" > /arsip/test.txt

cat <<'EOF' > /etc/apache2/sites-available/vault.conf
<VirtualHost *:80>
    ServerName vault.k36.com
    DocumentRoot /var/www/html
    Alias /arsip /arsip
    <Directory /arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2ensite vault.conf
systemctl reload apache2