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

# Nomor 9: Web Statis Apache & Autoindex
apt update; apt install apache2 curl dnsutils -y
mkdir -p /arsip/dokumen /var/www/html
echo "Halo, ini file dari Vault - DESMOND" > /arsip/test.txt
echo "Isi catatan" > /arsip/dokumen/catatan.txt

# Perbaikan permission agar tidak 403 Forbidden
chmod -R 755 /arsip
chown -R www-data:www-data /arsip

cat > /etc/apache2/sites-available/vault.conf <<'EOF'
<VirtualHost *:80>
    ServerName vault.k36.com
    ServerAlias obladi.k36.com desmond.k36.com
    DocumentRoot /var/www/html
    Alias /arsip /arsip
    <Directory /arsip>
        Options +Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername
a2enmod autoindex
a2dissite 000-default
a2ensite vault.conf
apache2ctl configtest
service apache2 restart