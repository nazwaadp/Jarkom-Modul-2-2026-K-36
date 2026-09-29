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

# Nomor 11: Apache Reverse Proxy & Load Balancer
apt update && apt install apache2 -y
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

cat <<'EOF' > /etc/apache2/sites-available/penny-proxy.conf
<VirtualHost *:80>
    ServerName www.k36.com
    
    <Proxy balancer://vaultcluster>
        BalancerMember http://192.229.1.4
        BalancerMember http://192.229.1.5
    </Proxy>
    
    ProxyPreserveHost On
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s
    
    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/
</VirtualHost>
EOF

a2ensite penny-proxy.conf
systemctl restart apache2