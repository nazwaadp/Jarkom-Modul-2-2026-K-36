#!/bin/bash

# SOAL 9 - Web statis Apache + autoindex /arsip/ (area vault)

vault_web() {
NAMA="$1"   # OBLADI / DESMOND

# [NODE: obladi / desmond]
apt update; apt install apache2 curl dnsutils -y
mkdir -p /arsip/dokumen /var/www/html
echo "Halo, ini file dari Vault - $NAMA" > /arsip/test.txt
echo "Isi catatan" > /arsip/dokumen/catatan.txt

# Perbaikan permission agar tidak 403 Forbidden
chmod -R 755 /arsip
chown -R www-data:www-data /arsip

# [NODE: obladi / desmond] -> /etc/apache2/sites-available/vault.conf
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
}

case "$1" in
  obladi)  vault_web "OBLADI" ;;
  desmond) vault_web "DESMOND" ;;
  *) echo "Pakai: bash soal9.sh <obladi|desmond>" ;;
esac
