#!/bin/bash

# SOAL 10 - Web dinamis Nginx + PHP-FPM + URL bersih /profil (area core)

core_web() {
NAMA_NODE="$1"

# [NODE: oblada / molly]
apt update && apt install nginx php-fpm curl dnsutils -y

mkdir -p /var/www/html

# [NODE: oblada / molly] -> /var/www/html/index.php
cat <<EOF > /var/www/html/index.php
<h1>Beranda Core - $NAMA_NODE</h1>
EOF

# [NODE: oblada / molly] -> /var/www/html/profil.php
cat <<EOF > /var/www/html/profil.php
<h1>Profil Core - $NAMA_NODE</h1>
EOF

# Deteksi versi PHP & jalankan PHP-FPM di background
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_SOCK="/run/php/php${PHP_VER}-fpm.sock"
php-fpm${PHP_VER} -D
sleep 1

# [NODE: oblada / molly] -> /etc/nginx/sites-available/core  (rewrite /profil)
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

rm -f /etc/nginx/sites-enabled/core
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/core /etc/nginx/sites-enabled/

nginx -t && service nginx restart
}

case "$1" in
  oblada|molly) core_web "$1" ;;
  *) echo "Pakai: bash soal10.sh <oblada|molly>" ;;
esac
