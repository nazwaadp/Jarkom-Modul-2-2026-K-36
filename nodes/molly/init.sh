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
nameserver 192.168.122.1
nameserver 192.229.1.3
EOF

NAMA_NODE="molly" 
IP_NODE="192.229.1.7" 

echo "$NAMA_NODE" > /etc/hostname
hostname $NAMA_NODE
echo "127.0.0.1 $NAMA_NODE" >> /etc/hosts

# Install Nginx & PHP-FPM
apt update && apt install nginx php-fpm curl dnsutils -y

mkdir -p /var/www/html

# Buat halaman beranda (index.php) pakai EOF
cat <<EOF > /var/www/html/index.php
<h1>Beranda Core - $NAMA_NODE</h1>
EOF

# Buat halaman profil (profil.php) pakai EOF
cat <<EOF > /var/www/html/profil.php
<h1>Profil Core - $NAMA_NODE</h1>
EOF

# Deteksi versi PHP & jalankan PHP-FPM di background secara aman
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_SOCK="/run/php/php${PHP_VER}-fpm.sock"
php-fpm${PHP_VER} -D
sleep 1

# Konfigurasi Nginx dengan Rewrite URL bersih untuk /profil
cat <<EOF > /etc/nginx/sites-available/core
server {
    listen 80;
    server_name core.k36.com;
    root /var/www/html;
    index index.php index.html;

    # URL Bersih untuk /profil
    location = /profil {
        rewrite ^/profil\$ /profil.php last;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$PHP_SOCK;
    }
}
EOF

# Aktifkan konfigurasi Nginx
rm -f /etc/nginx/sites-enabled/core
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/core /etc/nginx/sites-enabled/

nginx -t && service nginx restart