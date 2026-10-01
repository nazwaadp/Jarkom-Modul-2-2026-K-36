#!/bin/bash

# SOAL 5 - Hostname sesuai glosarium + A record tiap node di DNS

# [NODE: semua node] -> hostname system-wide
set_hostname() {
  echo "$1" > /etc/hostname
  hostname "$1"
  echo "127.0.0.1 $1" >> /etc/hosts
}

# [NODE: prab] -> /etc/bind/k36/k36.com  (tambah A record semua node)
dns_prab() {
cat <<'EOF' >> /etc/bind/k36/k36.com

alpha   IN      A       192.229.3.2
beta    IN      A       192.229.3.3
gamma   IN      A       192.229.3.4
delta   IN      A       192.229.5.2
epsilon IN      A       192.229.4.3
penny   IN      A       192.229.4.2
abbey   IN      A       192.229.2.2
obladi  IN      A       192.229.1.4
desmond IN      A       192.229.1.5
oblada  IN      A       192.229.1.6
molly   IN      A       192.229.1.7
EOF
service named restart || service bind9 restart
}

case "$1" in
  rootkit|alpha|beta|gamma|delta|epsilon|prab|tedd|abbey|penny|obladi|desmond|oblada|molly) set_hostname "$1" ;;
  dns) dns_prab ;;   # [NODE: prab] tambah A record: bash soal5.sh dns
  *) echo "Pakai: bash soal5.sh <rootkit|alpha|beta|gamma|delta|epsilon|prab|tedd|abbey|penny|obladi|desmond|oblada|molly>; untuk A record di prab: bash soal5.sh dns" ;;
esac
