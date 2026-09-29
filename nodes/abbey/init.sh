#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.229.2.2
        netmask 255.255.255.0
        gateway 192.229.2.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

echo "abbey" > /etc/hostname
hostname abbey
echo "127.0.0.1 abbey" >> /etc/hosts

# Install Nginx
apt update && apt install nginx curl dnsutils -y

# Konfigurasi Nginx Upstream ke Core Cluster
cat <<'EOF' > /etc/nginx/sites-available/abbey-proxy
upstream corecluster {
    server 192.229.1.6;
    server 192.229.1.7;
}

server {
    listen 80;
    server_name static.k36.com;

    location / {
        proxy_pass http://corecluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# Aktifkan konfigurasi Nginx
rm -f /etc/nginx/sites-enabled/core
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/abbey-proxy /etc/nginx/sites-enabled/

nginx -t && service nginx restart