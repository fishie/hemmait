cp /etc/letsencrypt/live/rishie.se/fullchain.pem /etc/pve/nodes/proxi/pve-ssl.pem
cp /etc/letsencrypt/live/rishie.se/privkey.pem /etc/pve/nodes/proxi/pve-ssl.key
systemctl restart pveproxy
