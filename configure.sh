apk update
apk add \
    docker \
    docker-compose \
    jq \
    micro
rc-update add docker
rc-service docker start

while ! docker info > /dev/null 2>&1; do
    echo "Docker is not running yet. Waiting..."
    sleep 1
done

## UniFi OS setup
unifi_os_folder='unifi-os'
repo_url='https://raw.githubusercontent.com/fishie/hemmait/main/unifi-os'

mkdir "$unifi_os_folder"
cd "$unifi_os_folder"
wget -O compose.yaml "$repo_url/compose.yaml"
wget -O update.sh "$repo_url/update.sh"
chmod +x update.sh
docker compose up -d
cd ..

## Home Assistant setup
home_assistant_folder='home-assistant'
repo_url='https://raw.githubusercontent.com/fishie/hemmait/main/home-assistant'

mkdir "$home_assistant_folder"
cd "$home_assistant_folder"
wget -O compose.yaml "$repo_url/compose.yaml"
wget -O update.sh "$repo_url/update.sh"
chmod +x update.sh
docker compose up -d
cd ..
