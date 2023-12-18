apk update
apk add docker docker-compose micro
rc-update add docker
service docker start

unifi_folder='unifi-network-application'
mkdir -p "/etc/$unifi_folder/mongo/"
wget -O "/etc/$unifi_folder/mongo/init-mongo.js" https://raw.githubusercontent.com/fishie/hemmait/main/unifi/init-mongo.js
mkdir "$unifi_folder"
wget -O "$unifi_folder/compose.yml" https://raw.githubusercontent.com/fishie/hemmait/main/unifi/compose.yml
cd "$unifi_folder"

while ! docker info > /dev/null 2>&1; do
    echo "Docker is not running yet. Waiting..."
    sleep 1
done

docker compose up -d
