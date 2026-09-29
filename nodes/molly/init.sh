#!/bin/bash

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.229.1.7
	netmask 255.255.255.0
	gateway 192.229.1.1
EOF

cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF

#!/bin/bash
NAMA_NODE="molly"      # UBAH MENJADI molly JIKA DI NODE MOLLY
IP_NODE="192.229.1.7"   # UBAH MENJADI 192.229.1.7 JIKA DI NODE MOLLY

echo "$NAMA_NODE" > /etc/hostname
hostname $NAMA_NODE
echo "127.0.0.1 $NAMA_NODE" >> /etc/hosts


# Nomor 10: Nginx & PHP-FPM, URL Rewrite
apt update && apt install nginx php-fpm -y

echo "<h1>Beranda Core - $NAMA_NODE</h1>" > /var/www/html/index.php
echo "<h1>Profil Core - $NAMA_NODE</h1>" > /var/www/html/profil.php

PHP_SOCK=$(find /run/php/ -name "*.sock" | head -n 1)

cat <<EOF > /etc/nginx/sites-available/core
server {
    listen 80;
    server_name core.k36.com;
    root /var/www/html;
    index index.php index.html;

    # URL Bersih untuk /profil
    location = /profil {
        rewrite ^/profil$ /profil.php last;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$PHP_SOCK;
    }
}
EOF

ln -s /etc/nginx/sites-available/core /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx