#!/bin/bash

# SOAL 7 - A record vault/core + CNAME www & static
# [NODE: prab] -> /etc/bind/k36/k36.com

cat <<'EOF' >> /etc/bind/k36/k36.com

vault   IN      A       192.229.1.4
vault   IN      A       192.229.1.5
core    IN      A       192.229.1.6
core    IN      A       192.229.1.7
www     IN      CNAME   penny.k36.com.
static  IN      CNAME   abbey.k36.com.
EOF

service named restart || service bind9 restart
