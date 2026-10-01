#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.4.2
        netmask 255.255.255.0
        gateway 192.229.4.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

echo "penny" > /etc/hostname
hostname penny
echo "127.0.0.1 penny" >> /etc/hosts

# Install Apache & modul proxy yang dibutuhkan
apt update && apt install apache2 curl dnsutils -y
a2enmod proxy proxy_balancer proxy_http lbmethod_byrequests headers

# Konfigurasi VirtualHost Apache Reverse Proxy ke Vault Cluster
cat <<'EOF' > /etc/apache2/sites-available/penny-proxy.conf
<VirtualHost *:80>
    ServerName www.k36.com

    <Proxy balancer://vaultcluster>
        BalancerMember http://192.229.1.4
        BalancerMember http://192.229.1.5
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPreserveHost On
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s

    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/
</VirtualHost>
EOF

echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername
a2dissite 000-default.conf
a2ensite penny-proxy.conf
apache2ctl configtest
service apache2 restart

cat <<'EOF' > /etc/apache2/sites-available/000-redirect.conf
<VirtualHost *:80>
    ServerName penny.k36.com
    ServerAlias 192.229.4.2
    Redirect permanent / http://www.k36.com/
</VirtualHost>
EOF

a2ensite 000-redirect.conf
apache2ctl configtest
service apache2 restart