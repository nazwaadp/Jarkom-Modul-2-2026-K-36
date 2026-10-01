#!/bin/bash

# SOAL 11 - Reverse proxy + load balancing
#   penny (Apache) -> vault (obladi & desmond)
#   abbey (Nginx)  -> core  (oblada & molly)


node_penny() {
# [NODE: penny]
apt update && apt install apache2 curl dnsutils -y
a2enmod proxy proxy_balancer proxy_http lbmethod_byrequests headers

# [NODE: penny] -> /etc/apache2/sites-available/penny-proxy.conf
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
}

node_abbey() {
# [NODE: abbey]
apt update && apt install nginx curl dnsutils -y

# [NODE: abbey] -> /etc/nginx/sites-available/abbey-proxy
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

rm -f /etc/nginx/sites-enabled/core
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/abbey-proxy /etc/nginx/sites-enabled/

nginx -t && service nginx restart
}

case "$1" in penny) node_penny ;; abbey) node_abbey ;; *) echo "Pakai: bash soal11.sh <penny|abbey>" ;; esac
