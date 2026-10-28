apk update
apk add docker docker-compose micro pwgen
rc-update add docker
rc-service docker start

unifi_os_folder='unifi-os'
repo_url='https://raw.githubusercontent.com/fishie/hemmait/main/unifi-os'

mkdir "$unifi_os_folder"
wget -O "$unifi_os_folder/compose.yaml" "$repo_url/compose.yaml"
cd "$unifi_os_folder"

while ! docker info > /dev/null 2>&1; do
    echo "Docker is not running yet. Waiting..."
    sleep 1
done

docker compose up -d
