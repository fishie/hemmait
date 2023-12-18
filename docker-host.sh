apk update
apk add docker micro
rc-update add docker
service docker start

unifi_folder='unifi-network-application'
mkdir -p "/etc/$unifi_folder/mongo/"
wget -O "/etc/$unifi_folder/mongo/init-mongo.js"
mkdir "$unifi_folder"
wget -O "$unifi_folder/compose.yml"
cd "$unifi_folder"
docker compose up -d