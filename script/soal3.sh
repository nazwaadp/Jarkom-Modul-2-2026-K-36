#!/bin/bash

# SOAL 3 - Routing internal + resolver 192.168.122.1
# Routing internal aktif karena gateway (soal1) + ip_forward di rootkit (soal2).

# [NODE: alpha, beta, gamma, delta, epsilon, prab, tedd, abbey, penny,
#        obladi, desmond, oblada, molly] -> /etc/resolv.conf
resolv_klien() {
cat <<'EOF' > /etc/resolv.conf
nameserver 192.229.1.2
nameserver 192.229.1.3
nameserver 192.168.122.1
EOF
}

case "$1" in
  rootkit)
    # [NODE: rootkit] -> /etc/resolv.conf
    echo "nameserver 192.168.122.1" > /etc/resolv.conf ;;
  alpha|beta|gamma|delta|epsilon|prab|tedd|abbey|penny|obladi|desmond|oblada|molly)
    resolv_klien ;;
  *) echo "Pakai: bash soal3.sh <nama_node>" ;;
esac

