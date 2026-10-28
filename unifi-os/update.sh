#!/usr/bin/fish

set compose_file /root/unifi-os/compose.yaml
set latest_version (wget -qO- https://api.github.com/repos/Gill-Bates/unifi-os-server/releases/latest | jq -r .tag_name | sed "s/^v//")

echo "UniFi OS"
set current_version (docker image inspect giiibates/unifi-os-server:latest --format "{{index .Config.Labels \"org.opencontainers.image.version\"}}")
echo "  Current version:  $current_version"
echo "  Latest version:   $latest_version"

if test "$current_version" != "$latest_version"
    docker compose -f $compose_file pull && \
    docker compose -f $compose_file up --force-recreate -d && \
    docker system prune -f
end
