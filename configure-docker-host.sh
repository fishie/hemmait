apk update
apk add docker docker-compose micro pwgen nginx py3-pip
rc-update add docker
rc-service docker start

unifi_folder='unifi-network-application'
repo_url='https://raw.githubusercontent.com/fishie/hemmait/main/unifi'

export MONGO_PASS=$(pwgen -s)
mkdir -p "/etc/$unifi_folder/mongo/"
wget -O "/etc/$unifi_folder/mongo/init-mongo.js" "$repo_url/init-mongo.js"
sed -i "s/\$MONGO_PASS/$MONGO_PASS/g" "/etc/$unifi_folder/mongo/init-mongo.js"

mkdir "$unifi_folder"
wget -O "$unifi_folder/compose.yml" "$repo_url/compose.yml"
cd "$unifi_folder"

while ! docker info > /dev/null 2>&1; do
    echo "Docker is not running yet. Waiting..."
    sleep 1
done

docker compose up -d

python3 -m venv /root/certbot-venv
source /root/certbot-venv/bin/activate
pip install certbot certbot-dns-cloudflare

echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" > /etc/letsencrypt/cloudflare.ini
chmod 600 /etc/letsencrypt/cloudflare.ini
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d unifi.rishie.se --agree-tos --non-interactive -m "$EMAIL"

wget -O /etc/nginx/http.d/unifi.conf "$repo_url/nginx-unfi.conf"
rc-update add nginx
rc-service nginx start

wget -O /etc/periodic/daily/certbot-renew "$repo_url/certbot-renew"
chmod +x /etc/periodic/daily/certbot-renew
