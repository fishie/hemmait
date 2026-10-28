apk update
apk add \
    docker \
    docker-compose \
    fish \
    git \
    jq \
    micro \
    nginx \
    samba
rc-update add docker
rc-service docker start

while ! docker info > /dev/null 2>&1; do
    echo "Docker is not running yet. Waiting..."
    sleep 1
done

repo_url='https://raw.githubusercontent.com/fishie/hemmait/main'

## UniFi OS setup
unifi_os_folder='unifi-os'
mkdir "$unifi_os_folder"
cd "$unifi_os_folder"
wget -O compose.yaml "$repo_url/$unifi_os_folder/compose.yaml"
wget -O update.sh "$repo_url/$unifi_os_folder/update.sh"
chmod +x update.sh
docker compose up -d
cd ..

## Home Assistant setup
home_assistant_folder='home-assistant'
mkdir "$home_assistant_folder"
cd "$home_assistant_folder"
wget -O compose.yaml "$repo_url/$home_assistant_folder/compose.yaml"
wget -O update.sh "$repo_url/$home_assistant_folder/update.sh"
chmod +x update.sh
docker compose up -d
cd ..
